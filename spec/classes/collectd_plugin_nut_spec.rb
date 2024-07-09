# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::nut', type: :class do
  let :pre_condition do
    'include collectd'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context ':ensure => present, default params' do
        it 'Will create /etc/collectd.d/10-nut.conf' do
          is_expected.to contain_file('nut.load').
            with(ensure: 'present',
                 path: '/etc/collectd.d/10-nut.conf',
                 content: %r{LoadPlugin nut})
        end
      end

      context ':ensure => present, single entry' do
        let :params do
          { upss: ['ups1@localhost'] }
        end

        it 'Will create /etc/collectd.d/nut-ups-ups1@localhost.conf' do
          is_expected.to contain_file('/etc/collectd.d/nut-ups-ups1@localhost.conf').
            with(ensure: 'present',
                 path: '/etc/collectd.d/nut-ups-ups1@localhost.conf',
                 content: %r{UPS "ups1@localhost"})
        end
      end
    end
  end
end
