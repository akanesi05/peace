class BookmarksController < ApplicationController
  def create
    pose = Pose.find(params[:pose_id])
    current_user.bookmark(pose)
    redirect_to poses_path, success: t('.success')
   end
    
   def destroy
    pose = current_user.bookmarks.find(params[:id]).pose
        current_user.unbookmark(pose)
        redirect_to poses_path, success: t('.success'), status: :see_other
      end
end
