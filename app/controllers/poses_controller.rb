# frozen_string_literal: true

class PosesController < ApplicationController
  skip_before_action :require_login, only: %i[show index ranking]
  def index
    @q = Pose.ransack(params[:q])
    @poses = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])

    if params[:q].present? && params[:q][:name_cont].present? # フォームに名前が検索されたときにtrueが返ります
      @tag = Tag.find_by(name: params[:q][:name_cont]) # タグ名でタグを取得
      @poses = @tag.poses.page(params[:page]) if @tag # タグが見つかった場合にポーズを取得#フォームに入力したタグ名に紐づいている投稿を引っ張ろうとしている。
    else
      @poses = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
    end
  end

  def show
    @pose = Pose.find(params[:id])
  end

  def new
    @pose = Pose.new
  end

  # Pose.where('? <= created_at', "2024-04-11").where(user_id:2).count
  def create
    tag_names = params[:tag_name].split(',')
    # 2. タグ名の配列をタグの配列にする
    tags = tag_names.map { |tag_name| Tag.find_or_initialize_by(name: tag_name) }
    # 3. タグのバリデーションを行い、バリデーションエラーがあればPostのエラーに加える
    tags.each do |tag|
      next unless tag.invalid?

      @tag_name = params[:tag_name]
      @pose.errors.add(:tags, tag.errors.full_messages.join("\n"))
      return render :edit, status: :unprocessable_entity
    end
    # p "22行目の時の件数"+ Pose.where('? <= created_at', Date.today).where(user_id:current_user.id).count.to_s
    pose_count = Pose.where('? <= created_at', Date.today).where(user_id: current_user.id).count
    if pose_count >= 5
      flash.now[:danger] = '1日の投稿上限に達しました'
      return render :new, status: :unprocessable_entity
    end
    @pose = current_user.poses.build(pose_params)
    render :new, status: :unprocessable_entity unless @pose.save

    # ここからメソッド化する
    # ファイル名に付ける乱数を生成
    random = rand(1..999_999)

    # パラメータから画像を取得し一時ファイルとして保存
    public_path_base = "public/uploads/tmp/#{random}"
    tmp_image = pose_params[:image]
    return unless tmp_image.present?

    original_filename = tmp_image.original_filename
    # tmp_image_extention = tmp_image.content_type
    tmp_image_path = "#{public_path_base}/tmp_#{original_filename}"
    Dir.mkdir(public_path_base)
    File.binwrite(tmp_image_path, tmp_image.read)

    # flash.now[:danger] = "画像が選択されていません。"  # ここを追加

    # 公式ドキュメントコピペここからhttps://docs.aws.amazon.com/ja_jp/rekognition/latest/dg/faces-detect-images.html
    require 'aws-sdk-rekognition'
    credentials = Aws::Credentials.new(
      ENV['AWS_ACCESS_KEY_ID'],
      ENV['AWS_SECRET_ACCESS_KEY']
    )

    client = Aws::Rekognition::Client.new(region: ENV['AWS_REGION'], credentials:)
    attrs = {
      image: {
        bytes: File.read(tmp_image_path)
      }
    }
    image = MiniMagick::Image.open(tmp_image_path)
    image_width = image.width
    image_height = image.height

    response = client.detect_faces(attrs)
    puts 'Detected faces for: '
    response.face_details.each do |face_detail|
      puts 'All other attributes:'
      puts "  bounding_box.width:     #{face_detail.bounding_box.width}"
      puts "  bounding_box.height:    #{face_detail.bounding_box.height}"
      puts "  bounding_box.left:      #{face_detail.bounding_box.left}"
      puts "  bounding_box.top:       #{face_detail.bounding_box.top}"
      puts '------------'
      puts ''
      image.combine_options do |edit|
        rect_x_ratio = face_detail.bounding_box.left
        rect_y_ratio = face_detail.bounding_box.top
        rect_width_ratio = face_detail.bounding_box.width
        rect_height_ratio = face_detail.bounding_box.height

        edit.fill('#ffffff')
        rect_x = image_width * rect_x_ratio
        rect_y = image_height * rect_y_ratio
        rect_width = rect_x + image_width * rect_width_ratio
        rect_height = rect_y + image_height * rect_height_ratio

        edit.draw("rectangle #{rect_x},#{rect_y},#{rect_width},#{rect_height}")
      end
    end

    # 画像を保存する
    result_image_path = "#{public_path_base}/result_#{original_filename}"
    image.write(result_image_path)

    # 画像をモデルに設定する
    File.open(result_image_path) do |file|
      @pose.image = file
    end
    # 一時画像たちを削除する
    # File.delete(result_image_path)
    # File.delete(tmp_image_path)
    # reqiure 'fileutils'

    FileUtils.rm_r(public_path_base) # ディレクトリを丸ごと削除

    # ここまでメソッド化する
    # AWSドキュメントからの参考ここまで

    @pose.tags = tags
    if @pose.save
      # p "100行目の時の件数"+ Pose.where('? <= created_at', Date.today).where(user_id:current_user.id).count.to_s
      # redirect_to @pose, notice: 'Pose was successfully created.'
      redirect_to poses_path, success: t('defaults.flash_message.created', item: Pose.model_name.human)
    else
      @tag_name = params[:tag_name]
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Pose.model_name.human)
      render :new
    end
  end

  def edit
    @pose = current_user.poses.find(params[:id])
  end

  def update
    @pose = current_user.poses.find(params[:id])
    if @pose.update(pose_params)
      redirect_to pose_path(@pose), success: t('defaults.flash_message.updated', item: Pose.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Pose.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    pose = current_user.poses.find(params[:id])
    pose.destroy!
    redirect_to poses_path, success: t('defaults.flash_message.deleted', item: Pose.model_name.human),
                            status: :see_other
  end

  def bookmarks
    @q = current_user.bookmark_poses.ransack(params[:q])
    @bookmark_poses = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  # 候補を出すためのメソッド
  def search
    @poses = Pose.where('name like ?', "%#{params[:q]}%")
    respond_to(&:js)
  end

  def ranking
    @poses = Pose.left_joins(:bookmarks)
                 .group(:id)
                 .select('poses.*, COUNT(bookmarks.id) AS bookmarks_count')
                 .order('bookmarks_count DESC').limit(3)

    @ranked_poses = []
    current_rank = 1
    previous_count = nil

    @poses.each_with_index do |pose, index|
      current_rank = index + 1 if previous_count != pose.bookmarks_count
      @ranked_poses << { pose:, rank: current_rank }
      previous_count = pose.bookmarks_count
    end
  end

  private

  def pose_params
    params.require(:pose).permit(:name, :image)
  end
end
