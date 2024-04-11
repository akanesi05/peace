class PosesController < ApplicationController
  def index
    #@poses = Pose.where.not(image: nil).includes(:user).order(created_at: :desc)
    @q = Pose.ransack(params[:q])
  
    @poses = @q.result(distinct: true).where.not(image: nil).includes(:user).order(created_at: :desc).page(params[:page])
   
  end
    
  def show
    @pose = Pose.find(params[:id])
  end
    
  def new
    @pose = Pose.new
    
  end


   #Pose.where('? <= created_at', "2024-04-11").where(user_id:2).count 
  def create
    pose_count = Pose.where('? <= created_at', Date.today).where(user_id:current_user.id).count 
    if pose_count > 4
      return render :new
    end
    @pose = current_user.poses.build(pose_params)
    unless @pose.save
      render :new
    end

    image_path = @pose.image.current_path

    #公式ドキュメントコピペここからhttps://docs.aws.amazon.com/ja_jp/rekognition/latest/dg/faces-detect-images.html
    require 'aws-sdk-rekognition'
    credentials = Aws::Credentials.new(
       ENV['AWS_ACCESS_KEY_ID'],
       ENV['AWS_SECRET_ACCESS_KEY']

    )
    
   
    # img = "./app/assets/images/aaa.jpg"
    client   = Aws::Rekognition::Client.new(region: ENV['AWS_REGION'],credentials: credentials)
    attrs = {
      image: {
        bytes: File.read(image_path)
      }
    }
    image = MiniMagick::Image.open(image_path)
    image_width = image.width
    image_height = image.height

    response = client.detect_faces attrs
    puts "Detected faces for: "
    response.face_details.each do |face_detail|
      puts "All other attributes:"
      puts "  bounding_box.width:     #{face_detail.bounding_box.width}"
      puts "  bounding_box.height:    #{face_detail.bounding_box.height}"
      puts "  bounding_box.left:      #{face_detail.bounding_box.left}"
      puts "  bounding_box.top:       #{face_detail.bounding_box.top}"
      puts "------------"
      puts ""
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
      end # the command gets executed
  
    end

    random = rand(1..999999)

    # 画像を保存する
    image.write("./app/assets/images/result#{random}.jpg")

    # 画像をモデルに設定する
    File.open("./app/assets/images/result#{random}.jpg") do |file|
      @pose.image = file
    end
    #画像を削除する
    File.delete("./app/assets/images/result#{random}.jpg")

    #コピペここまで
    if @pose.save
      redirect_to @pose, notice: 'Pose was successfully created.'
    else
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
    redirect_to poses_path, success: t('defaults.flash_message.deleted', item: Pose.model_name.human), status: :see_other
  
  end

  def bookmarks
    
    @q = current_user.bookmark_poses.ransack(params[:q])
    @bookmark_poses = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
    
  end
  

  def search
    @poses = Pose.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end

    
  end 
 
  def ranking 
    
    @poses = Pose.joins(:bookmarks) # ポーズとブックマークを結合
                  .select('poses.*, COUNT(bookmarks.id) AS bookmarks_count') 
                  #.where(challenge_result: 'complete')
                  # ポーズごとのブックマークの数をカウント
                  .group('poses.id') # ポーズごとにグループ化
                  .order('bookmarks_count DESC') # ブックマークの数で降順にソート
                  .limit(10) # 上位10件のみ取得
                  .includes(:user) # ポーズに関連するユーザー情報を取得（N+1問題を避けるため）
  end
  
  private
    
  def pose_params
      params.require(:pose).permit(:name, :image)
  end

  
  # Only allow a list of trusted parameters through.
  
end
