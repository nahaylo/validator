require 'spec_helper'
require 'test_classes/ip_address'

module ActiveModel
  module Validations
    describe IpAddressValidator do
      let(:ip_address) { TestIpAddress.new }
      let(:ip_address_prefix) { TestIpAddressWithPrefix.new }
      let(:ip_address4) { TestIpAddress4.new }
      let(:ip_address6) { TestIpAddress6.new }
      let(:ip_address_with_message) { TestIpAddressWithMessage.new }

      describe "validations" do
        # for blank ip
        it { ip_address.should be_valid }

        describe 'valid' do
          context "IPv4" do
            it "should be valid any ip address" do
              ip_address.ip = '127.0.0.1'
              ip_address.should_not have_errors_on(:ip)
            end

            it "should be valid IPv4 address" do
              ip_address4.ip = '127.0.0.1'
              ip_address4.should_not have_errors_on(:ip)
            end

            it "should be valid IPv4 address with prefix" do
              ip_address_prefix.ip = '127.0.0.1/32'
              ip_address_prefix.should_not have_errors_on(:ip)
            end
          end

          context "IPv6" do
            it "should be valid any ip address" do
              ip_address.ip = '2001:0db8:0000:0000:0008:0800:200c:417a'
              ip_address.should_not have_errors_on(:ip)
            end

            it "should be valid IPv6 address" do
              ip_address6.ip = '2001:0db8:0000:0000:0008:0800:200c:417a'
              ip_address6.should_not have_errors_on(:ip)
            end

            it "should be valid IPv6 address (short format)" do
              ip_address.ip = '2001:db8::8:800:200c:417a'
              ip_address.should_not have_errors_on(:ip)
            end

            it "should be valid IPv6 address with prefix" do
              ip_address_prefix.ip = '2001:db8::8:800:200c:417a/128'
              ip_address_prefix.should_not have_errors_on(:ip)
            end
          end
        end

        describe "invalid" do
          context "IPv4" do
            it { # invalid IP address
              ip_address.ip = '127.0.0.1241'
              ip_address.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.invalid.general'))
            }

            it { # invalid IPv4 address
              ip_address4.ip = '127.0.0.1241'
              ip_address4.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.invalid.ipv4'))
            }

            it { # prefix not allowed
              ip_address.ip = '127.0.0.1/124'
              ip_address.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.prefix_disallowed'))
            }

            it { # invalid prefix
              ip_address_prefix.ip = '127.0.0.1/33'
              ip_address_prefix.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.prefix_invalid.ipv4'))
            }

            it 'should yield custom message' do
              ip_address_with_message.ip = '300.0.0.1'
              ip_address_with_message.should have_errors_on(:ip).with_message('invalid')
            end
          end

          context "IPv6" do
            it { # invalid IP address
              ip_address.ip = '_2001:db8::8:800:200c:417a'
              ip_address.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.invalid.general'))
            }

            it { # invalid IP address
              ip_address6.ip = '_2001:db8::8:800:200c:417az'
              ip_address6.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.invalid.ipv6'))
            }

            it { # prefix not allowed
              ip_address.ip = '2001:db8::8:800:200c:417a/64'
              ip_address.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.prefix_disallowed'))
            }

            it { # invalid prefix
              ip_address_prefix.ip = '2001:db8::8:800:200c:417a/129'
              ip_address_prefix.should have_errors_on(:ip).with_message(I18n.t(:'errors.messages.ip_address.prefix_invalid.ipv6'))
            }

            it 'should yield custom message' do
              ip_address_with_message.ip = '_2001:db8::8:800:200c:417a'
              ip_address_with_message.should have_errors_on(:ip).with_message('invalid')
            end
          end
        end
      end
    end
  end
end

