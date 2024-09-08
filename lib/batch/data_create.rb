# frozen_string_literal: true

module Batch
  class DataCreate
    def self.data_create
      # ユーザーテーブルの全てのユーザーを取得
      User.all.each do |user|
        # ユーザーごとのポーズの数をカウント
        pose_count = user.poses.count

        # PoseCountテーブルからuser_idが一致するレコードを取得または新規作成

        # ポーズの数をレコードにセット
        pose_count_record.pose_count = pose_count

        # レコードを保存
        pose_count_record.save
      end
    end
  end
end
