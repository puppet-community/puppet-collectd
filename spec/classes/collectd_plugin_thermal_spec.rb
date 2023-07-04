# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::thermal', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        let :params do
          {
            devices: ['foo0'],
            ensure: 'present'
          }
        end

        it { is_expected.to contain_collectd__plugin('thermal') }

        it 'Will create 10-thermal.conf' do
          is_expected.to contain_file('thermal.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-thermal.conf",
            content: "#\ Generated by Puppet\n<LoadPlugin thermal>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"thermal\">\n  Device \"foo0\"\n  IgnoreSelected false\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-thermal.conf' do
          is_expected.to contain_file('thermal.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-thermal.conf"
          )
        end
      end

      context ':devices is not an array' do
        let :params do
          { devices: 'foo0' }
        end

        it 'Will raise an error about :devices not being an array' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end
    end
  end
end
