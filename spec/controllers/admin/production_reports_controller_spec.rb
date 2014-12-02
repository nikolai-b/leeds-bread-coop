describe Admin::ProductionReportsController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let!(:order) { create :order }

  describe 'routing' do
    it { is_expected.to route(:get,     "/admin/production_reports/#{Date.current.strftime}").to(action: :show, date: Date.current.strftime) }
  end

  describe 'show' do
    before { get :show, date: (Date.current + 2.days).strftime }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end
end
