describe OrdersController do
  let(:admin) { create :subscriber, :admin }

  it 'copies regular orders with admin email' do
    expect(Order).to receive(:copy_regular_orders)

    get :copy, {admin_email: admin.email}
  end

  it 'renders home without admin email' do
    get :copy, {admin_email: "non_admin@example.com"}
    expect(response.status).to eq(302)
  end
end

