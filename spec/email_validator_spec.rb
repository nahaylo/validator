require 'spec_helper'
require 'test_classes/email'

module ActiveModel
  module Validations
    describe EmailValidator do
      let(:email) { TestEmail.new }
      let(:email_with_domain_length) { TestEmailWithDomainLength.new }
      let(:email_with_message) { TestEmailWithMessage.new }

      describe "validations" do
        # for blank email
        it { email.should be_valid }

        describe 'valid' do

          it {
            [
              "a+b@plus-in-local.com",
              "a_b@underscore-in-local.com",
              "user@example.com",
              "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
              "01234567890@numbers-in-local.net",
              "a@single-character-in-local.org",
              "one-character-third-level@a.example.com",
              "single-character-in-sld@x.org",
              "local@dash-in-sld.com",
              "letters-in-sld@123.com",
              "one-letter-sld@x.org",
              "uncommon-tld@sld.museum",
              "uncommon-tld@sld.travel",
              "uncommon-tld@sld.mobi",
              "country-code-tld@sld.uk",
              "country-code-tld@sld.rw",
              "local@sld.newTLD",
              "local@sub.domains.com",
              "aaa@bbb.co.jp",
              "nigel.worthington@big.co.uk",
              "f@c.com",
              "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
              "valid@#{'a'*63}.#{'b'*63}.#{'c'*63}.#{'d'*59}.com",
              "valid@#{'w'*63}.com"
            ].each do |e|
              email.email = e
              email.should_not have_errors_on(:email)
            end
          }

          it "should be valid with local part length 64" do
            email.email = "valid_because_of_length#{'w'*41}@valid.domain.com"
            email.should_not have_errors_on(:email)
          end

          it "should be valid for custom length and label length" do
            email_with_domain_length.email = "valid@valid-domain.com"
            email_with_domain_length.should be_valid
          end

        end

        describe 'invalid' do
          it "if consists of more then two @" do
            email.email = 'invali@email@domain.com'
            email.should have_errors_on(:email).with_message(I18n.t(:'errors.messages.email.invalid'))
          end

          it {
            email.email = "invalid_because_of_length#{'w'*41}@valid.domain.com"
            email.should have_errors_on(:email).with_message(I18n.t(:'errors.messages.email.local_length', :local_length => 64))
          }

          it {
            [
              "f@s",
              "f@s.c",
              "@bar.com",
              "test@example.com@example.com",
              "test@",
              "@missing-local.org",
              "a b@space-in-local.com",
              "! \#$%\`|@invalid-characters-in-local.org",
              "<>@[]\`|@even-more-invalid-characters-in-local.org",
              "missing-sld@.com",
              "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
              "missing-dot-before-tld@com",
              "missing-tld@sld.",
              "missing-at-sign.net",
              "unbracketed-IP@127.0.0.1",
              "invalid-ip@127.0.0.1.26",
              "another-invalid-ip@127.0.0.256",
              "IP-and-port@127.0.0.1:25",
              "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
              "valid@not-valid-because-of-length-#{'w'*230}.com"
            ].each do |e|
              email.email = e
              email.should have_errors_on(:email)#.with_message(I18n.t(:'errors.messages.email.invalid_format'))
              #puts email.errors.full_messages
            end
          }

          it {
            email.email = "valid-local-part@not-valid-because-of-length-#{'w'*230}.com"
            email.should have_errors_on(:email).with_message(I18n.t(:'errors.messages.email.domain.length', :domain_length => 255))
          }

          it {
            email.email = "valid-local-part@not-valid-because-of-length-of-label#{'w'*230}.com"
            email.should have_errors_on(:email, 2).with_message(I18n.t(:'errors.messages.email.domain.label_length', :domain_label_length => 63))
          }

          it {
            email.email = "valid-local-part@#{'w'*64}.com"
            email.should have_errors_on(:email).with_message(I18n.t(:'errors.messages.email.domain.label_length', :domain_label_length => 63))
          }

          context 'custom full domain length and label length' do
            it {
              email_with_domain_length.email = "valid-local-part@#{'w'*61}.com"
              email_with_domain_length.should have_errors_on(:email).with_message(I18n.t(:'errors.messages.email.domain.label_length', :domain_label_length => 60))
            }

            it {
              email_with_domain_length.email = "valid-local-part@not-valid-because-of-length-#{'w'*190}.com"
              email_with_domain_length.should have_errors_on(:email).with_message(I18n.t(:'errors.messages.email.domain.length', :domain_length => 200))
            }
          end

        end
      end
    end
  end
end

