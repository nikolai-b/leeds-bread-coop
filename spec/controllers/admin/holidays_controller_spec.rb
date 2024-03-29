describe Admin::HolidaysController, type: :controller do
  before do
    warden.set_user admin
  end

  let(:admin) { create :subscriber, :admin }
  let(:holiday) { create :holiday }
  let(:subscriber) { holiday.subscriber }
  let(:new_holiday) { build :holiday, start_date: (Date.today + 40.days), end_date: (Date.today + 50.days), subscriber: subscriber }

  describe 'routing' do
    it { is_expected.to route(:get,     "/admin/subscribers/#{subscriber.id}/holidays"       ).to(action: :index,   subscriber_id: subscriber.id) }
    it { is_expected.to route(:post,    "/admin/subscribers/#{subscriber.id}/holidays"       ).to(action: :create,  subscriber_id: subscriber.id) }
    it { is_expected.to route(:get,     "/admin/subscribers/#{subscriber.id}/holidays/new"   ).to(action: :new,     subscriber_id: subscriber.id) }
    it { is_expected.to route(:get,     "/admin/subscribers/#{subscriber.id}/holidays/1"     ).to(action: :show,    subscriber_id: subscriber.id, id: 1) }
    it { is_expected.to route(:get,     "/admin/subscribers/#{subscriber.id}/holidays/1/edit").to(action: :edit,    subscriber_id: subscriber.id, id: 1) }
    it { is_expected.to route(:put,     "/admin/subscribers/#{subscriber.id}/holidays/1"     ).to(action: :update,  subscriber_id: subscriber.id, id: 1) }
    it { is_expected.to route(:delete,  "/admin/subscribers/#{subscriber.id}/holidays/1"     ).to(action: :destroy, subscriber_id: subscriber.id, id: 1) }
  end

  describe 'index' do
    before { holiday; get :index, subscriber_id: subscriber.id}

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: holiday.to_param, subscriber_id: subscriber.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, holiday: new_holiday.attributes, subscriber_id: subscriber.id }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'create with warning' do
    before { post :create, holiday: new_holiday.attributes.merge(start_date: Date.tomorrow), subscriber_id: subscriber.id }
    it { is_expected.to set_the_flash.to(/with warning: Start date is/) }
  end

  describe 'update' do
    before { put :update, id: holiday.to_param,
             holiday: holiday.attributes.merge(end_date: (Date.today + 40.days)),
             subscriber_id: subscriber.id}

    it { is_expected.to redirect_to("/admin/subscribers/#{subscriber.id}/holidays/#{holiday.to_param}") }
  end

  describe 'update with warning' do
    before { put :update, id: holiday.to_param,
             holiday: holiday.attributes.merge(start_date: Date.tomorrow, end_date: (Date.today + 40.days)),
             subscriber_id: subscriber.id}

    it { is_expected.to redirect_to("/admin/subscribers/#{subscriber.id}/holidays/#{holiday.to_param}") }
    it { is_expected.to set_the_flash.to(/with warning: Start date is/) }
  end

  describe 'new' do
    before { get :new, subscriber_id: subscriber.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: holiday.to_param, subscriber_id: subscriber.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
