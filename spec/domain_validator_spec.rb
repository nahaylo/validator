require 'spec_helper'
require 'test_classes/domain'

module ActiveModel
  module Validations
    describe DomainValidator do
      let(:domain) { TestDomain.new }
      let(:domain_with_message) { TestDomainWithMessage.new }
      let(:domain_with_length) { TestDomainWithLength.new }
      let(:domain_without_tld) { TestDomainWithoutTld.new }

      describe "validations" do
        # for blank domain
        it { domain.should be_valid }

        describe 'valid' do

          it {
            domain.domain_name = 'this-should-be-valid.com'
            domain.should_not have_errors_on(:domain_name)
          }

          it "could start with letter" do
            domain.domain_name = "correct.com"
            domain.should_not have_errors_on(:domain_name)
          end

          it "could start with number" do
            domain.domain_name = "4correct.com"
            domain.should_not have_errors_on(:domain_name)
          end

          it "should be valid for domain with full length 255 and max length per label 63" do
            domain.domain_name = "#{'a'*63}.#{'b'*63}.#{'c'*63}.#{'d'*59}.com"
            domain.should_not have_errors_on(:domain_name)
          end

          it {
            domain.domain_name = "#{'w'*63}.com"
            domain.should_not have_errors_on(:domain_name)
          }

          it "should be valid with TLD [.com, .com.ua, .co.uk, .travel, .info, etc...]" do
            %w(.com .com.ua .co.uk .travel .info).each do |tld|
              domain.domain_name = "domain#{tld}"
              domain.should_not have_errors_on(:domain_name)
            end
          end

          it "should be valid if TLD length is between 2 and 6" do
            %w(ua museum).each do |tld|
              domain.domain_name = "domain.#{tld}"
              domain.should_not have_errors_on(:domain_name)
            end
          end

          it "should be valid for custom length and label length" do
            domain_with_length.domain_name = "valid-domain.com"
            domain_with_length.should be_valid
          end

          it "should be valid with unknown TLD" do
            domain_without_tld.domain_name = "valid-domain.abcabc"
            domain_without_tld.should be_valid      
          end

        end

        describe 'invalid' do
          it {
            domain.domain_name = "not-valid-because-of-length-#{'w'*230}.com"
            domain.should have_errors_on(:domain_name, 2).with_message(I18n.t(:'errors.messages.domain.length', :length => 255))
          }

          it {
            domain.domain_name = "not-valid-because-of-length-of-label#{'w'*230}.com"
            domain.should have_errors_on(:domain_name, 2).with_message(I18n.t(:'errors.messages.domain.label_length', :label_length => 63))
          }

          it {
            domain.domain_name = "#{'w'*64}.com"
            domain.should have_errors_on(:domain_name).with_message(I18n.t(:'errors.messages.domain.label_length', :label_length => 63))
          }

          it "should be invalid if consists of special symbols (&, _, {, ], *, etc)" do
            domain.domain_name = "&_{]*.com"
            domain.should have_errors_on(:domain_name).with_message(I18n.t(:'errors.messages.domain.invalid'))
          end

          it "should not start with special symbol" do
            domain.domain_name = "_incorrect.com"
            domain.should have_errors_on(:domain_name).with_message(I18n.t(:'errors.messages.domain.invalid'))
          end

          it 'should yield custom message' do
            domain_with_message.domain_name = '_invalid.com'
            domain_with_message.should have_errors_on(:domain_name).with_message('invalid')
          end

          it "should not be valid with TLD length more than 6" do
            domain_without_tld.domain_name = "domain.abcabcd"
            domain_without_tld.should have_errors_on(:domain_name)
          end

          it "should not be valid with unknown TLD" do
            domain.domain_name = "domain.abcabc"
            domain.should have_errors_on(:domain_name).with_message(I18n.t(:'errors.messages.domain.unknown_tld'))
          end

          it "should not be valid if TLD consists of numbers or special symbols (&, _, {, ], *, etc)" do
            %w(2 & _ { ] *).each do |tld|
              domain.domain_name = "domain.a#{tld}"
              domain.should have_errors_on(:domain_name)
            end
          end

          context 'custom full domain length and label length' do
            it {
              domain_with_length.domain_name = "#{'w'*61}.com"
              domain_with_length.should have_errors_on(:domain_name).with_message(I18n.t(:'errors.messages.domain.label_length', :label_length => 60))
            }

            it {
              domain_with_length.domain_name = "not_valid_because_of_length_#{'w'*190}.com"
              domain_with_length.should have_errors_on(:domain_name, 2).with_message(I18n.t(:'errors.messages.domain.length', :length => 200))
            }
          end

        end
      end
    end
  end
end

