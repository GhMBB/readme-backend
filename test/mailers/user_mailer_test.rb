require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "email_confirmation" do
    mail = UserMailer.email_confirmation
    assert_equal "Email confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "restore_password" do
    mail = UserMailer.restore_password
    assert_equal "Restore password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
