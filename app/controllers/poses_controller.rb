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


    
  def create
    @pose = current_user.poses.build(pose_params)
    #公式ドキュメントコピペここからhttps://docs.aws.amazon.com/ja_jp/rekognition/latest/dg/faces-detect-images.html
    require 'aws-sdk-rekognition'
    credentials = Aws::Credentials.new(
       ENV['AWS_ACCESS_KEY_ID'],
       ENV['AWS_SECRET_ACCESS_KEY']

    )
    
   #bucket = 'bucket' # the bucketname without s3://
    #photo  = 'input.jpg'# the name of file
    img = "/Users/mitsuiakane/Projects/peace/app/assets/images/ccc.jpg"
    client   = Aws::Rekognition::Client.new(region: ENV['AWS_REGION'],credentials: credentials)
    attrs = {
      image: {
        bytes: File.read(img)
    }
      #image: {
        #s3_object: {
          #3bucket: bucket,
          #name: photo
        #},
      #},
      #attributes: ['ALL']
    }
    response = client.detect_faces attrs
    puts "Detected faces for: "
    response.face_details.each do |face_detail|
      #low  = face_detail.age_range.low
      #high = face_detail.age_range.high
      #puts "The detected face is between: #{low} and #{high} years old"
      puts "All other attributes:"
      puts "  bounding_box.width:     #{face_detail.bounding_box.width}"
      puts "  bounding_box.height:    #{face_detail.bounding_box.height}"
      puts "  bounding_box.left:      #{face_detail.bounding_box.left}"
      puts "  bounding_box.top:       #{face_detail.bounding_box.top}"
      #puts "  age.range.low:          #{face_detail.age_range.low}"
      #puts "  age.range.high:         #{face_detail.age_range.high}"
      #puts "  smile.value:            #{face_detail.smile.value}"
      #puts "  smile.confidence:       #{face_detail.smile.confidence}"
      #puts "  eyeglasses.value:       #{face_detail.eyeglasses.value}"
      #puts "  eyeglasses.confidence:  #{face_detail.eyeglasses.confidence}"
      #puts "  sunglasses.value:       #{face_detail.sunglasses.value}"
      #puts "  sunglasses.confidence:  #{face_detail.sunglasses.confidence}"
      #puts "  gender.value:           #{face_detail.gender.value}"
      #puts "  gender.confidence:      #{face_detail.gender.confidence}"
      #puts "  beard.value:            #{face_detail.beard.value}"
      #puts "  beard.confidence:       #{face_detail.beard.confidence}"
      #puts "  mustache.value:         #{face_detail.mustache.value}"
      #puts "  mustache.confidence:    #{face_detail.mustache.confidence}"
      #puts "  eyes_open.value:        #{face_detail.eyes_open.value}"
      #puts "  eyes_open.confidence:   #{face_detail.eyes_open.confidence}"
      #puts "  mout_open.value:        #{face_detail.mouth_open.value}"
      #puts "  mout_open.confidence:   #{face_detail.mouth_open.confidence}"
      #puts "  emotions[0].type:       #{face_detail.emotions[0].type}"
      #puts "  emotions[0].confidence: #{face_detail.emotions[0].confidence}"
      #puts "  landmarks[0].type:      #{face_detail.landmarks[0].type}"
      #puts "  landmarks[0].x:         #{face_detail.landmarks[0].x}"
      #puts "  landmarks[0].y:         #{face_detail.landmarks[0].y}"
      # puts "  pose.roll:              #{face_detail.pose.roll}"
      # puts "  pose.yaw:               #{face_detail.pose.yaw}"
      # puts "  pose.pitch:             #{face_detail.pose.pitch}"
      # puts "  quality.brightness:     #{face_detail.quality.brightness}"
      # puts "  quality.sharpness:      #{face_detail.quality.sharpness}"
      # puts "  confidence:             #{face_detail.confidence}"
      puts "------------"
      puts ""
    end
    #original = MiniMagick::Image.read(File.read(img))
    image = MiniMagick::Image.open(img) 
    image_width = image.width
    image_height = image.height

    image.combine_options do |edit|
      #b.resize "250x200>"
      #b.rotate "-90"
      #edit.fill_opacity(0)
      # edit.stroke('red')
      # edit.stroke_width(3)
      # Draw rectangle
      # ulx = image.columns * response.face_details.first.bounding_box.left
      # uly = image.rows * response.face_details.first.bounding_box.top
      # w = image.columns * response.face_details.first.bounding_box.width
      # h = image.rows * response.face_details.first.bounding_box.height
      


      rect_x_ratio = response.face_details.first.bounding_box.left
      rect_y_ratio = response.face_details.first.bounding_box.top
      rect_width_ratio = response.face_details.first.bounding_box.width
      rect_height_ratio = response.face_details.first.bounding_box.height
      

      
      edit.fill('#ffffff')
      rect_x = image_width * rect_x_ratio
      rect_y = image_height * rect_y_ratio
      rect_width = rect_x + image_width * rect_width_ratio
      rect_height = rect_y + image_height * rect_height_ratio

      # edit.rectangle(ulx, uly, ulx + w, uly + h)
      # edit.draw(image)
      edit.draw("rectangle #{rect_x},#{rect_y},#{rect_width},#{rect_height}")
    end # the command gets executed
    image.write("/Users/mitsuiakane/Projects/peace/app/assets/images/result.jpg")
    # gc = MiniMagick::Draw.new

    # gc.fill_opacity(0)
    # gc.fill('transparent')
    # gc.stroke('red')
    # gc.stroke_width(3)

    # # Draw rectangle
    # ulx = original.columns * response.face_details.first.bounding_box.left
    # uly = original.rows * response.face_details.first.bounding_box.top
    # w = original.columns * response.face_details.first.bounding_box.width
    # h = original.rows * response.face_details.first.bounding_box.height

    # gc.rectangle(ulx, uly, ulx + w, uly + h)
    # gc.draw(original)

    # # new_image = original.blur_image(0.0, 10.0)
    # original.write("/Users/mitsuiakane/Projects/peace/app/assets/images/result.jpg")
    # #コピペここまで
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
