require 'rails_helper'

RSpec.describe 'Poseモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    # factoriesで作成したダミーデータを使用します。
    let(:user) { FactoryBot.create(:user) }
    let!(:pose) {build(:pose, user_id: user.id) }#ポーズの変数を作り、13とか２０行目で使っている。

    before do
      pose.image = fixture_file_upload('test.jpeg')
    end

    context '正常な値の場合' do
      it '有効であること' do
        expect(pose.valid?).to eq true
      end
    end
#ネームが空だと、テストが通る#無効であることがtrue画像があれば無効なデータとして扱われる　画像がないと自動的に無効になる
#valid?が有効だったらtrueを返すメソッド,invalid？が無効だったらtrue
    context '異常な値の場合' do
      it 'ネームが空だと無効であること' do
        pose.name = ""
        expect(pose.invalid?).to eq true
      end
    end
    context '異常な値の場合' do
      it '画像が空だと無効であること' do
        pose.image = ""
        expect(pose.invalid?).to eq true
      end
    end
  end
end
