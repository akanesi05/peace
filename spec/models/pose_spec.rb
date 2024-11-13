require 'rails_helper'

RSpec.describe 'Poseモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    # factoriesで作成したダミーデータを使用します。
    let(:user) { FactoryBot.create(:user) }
    let!(:pose) {build(:pose, user_id: user.id) }

   

    context '正常な値の場合' do
      it '存在チェックが効いていること' do
        pose.image = fixture_file_upload('test.jpeg')
        expect(pose.valid?).to eq true
      end
    end
  end
  # describe 'アソシエーションのテスト' do
  #   context 'customerモデルとの関係' do
  #     it 'N:1となっている' do
  #       expect(Pose.reflect_on_association(:user).macro).to eq :belongs_to
  #     end
  #   end

  #   # has_manyの関係性で記述するのもありです。
  #   # context 'PoseCommentモデルとの関係' do
  #     # it '1:Nとなっている' do
  #       # expect(Pose.reflect_on_association(:pose_comments).macro).to eq :has_many
  #     # end
  #   # end
  # end
end
