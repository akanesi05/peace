class BookmarksController < ApplicationController
  def create
    @pose = Pose.find(params[:pose_id])
    current_user.bookmark(@pose)
    
   end
    
   def destroy
    @pose = current_user.bookmarks.find(params[:id]).pose
        current_user.unbookmark(@pose)
    
      end
end
