describe Week do
  it 'has num' do
    expect(Week.num).to eq(-1)
    Week.create(week_num: 13)
    expect(Week.num).to eq(13)
  end

  it 'has num=' do
    Week.num = 15
    expect(Week.num).to eq(15)
    Week.num = 16
    expect(Week.num).to eq(16)
  end
end

