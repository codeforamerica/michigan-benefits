module FeatureHelper
  def xstep(title, &block)
    puts "PENDING STEP SKIPPED: #{title}" unless ENV["QUIET_TESTS"]
  end

  def step(title, &block)
    expect(find(".subhead").text).to eq title
    print title unless ENV["QUIET_TESTS"]
    block.call
    puts unless ENV["QUIET_TESTS"]
  end

  def save_and_open_preview
    file_preview_url = file_preview_url(host: "localhost:3000", file: save_page)
    `open #{file_preview_url}`
  end

  def wut
    save_and_open_preview
  end

  def flash
    find(".flash").text
  end

  def login_as_member(member=nil)
    member ||= create :member

    visit root_path
    click_on "Log In"
    fill_in "Email", with: member.email
    fill_in "Password", with: "password"
    click_button "Continue"
  end
end
