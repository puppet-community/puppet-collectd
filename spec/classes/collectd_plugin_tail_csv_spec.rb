# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::tail_csv', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'Minimal attributes' do
        let :params do
          {
            'metrics' => {
              'snort-dropped' => {
                'type' => 'percent',
                'value_from' => 1
              }
            },
            'files' => {
              '/var/log/snort/snort.stats' => {
                'collect' => %w[snort-dropped]
              }
            }
          }
        end

        it 'overrides defaults' do
          content = <<~EOS
            # Generated by Puppet
            <LoadPlugin tail_csv>
              Globals false
            </LoadPlugin>

            <Plugin "tail_csv">
              <Metric "snort-dropped">
                Type "percent"
                ValueFrom 1
              </Metric>
              <File "/var/log/snort/snort.stats">
                Collect "snort-dropped"
              </File>
            </Plugin>

          EOS

          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_file('tail_csv.load').with(
            content: content,
            path: "#{options[:plugin_conf_dir]}/10-tail_csv.conf"
          )
        end
      end

      context 'All attributes' do
        let :params do
          {
            'metrics' => {
              'snort-dropped' => {
                'type' => 'percent',
                'value_from' => 1,
                'instance' => 'dropped'
              },
              'snort-reject' => {
                'type' => 'percent',
                'value_from' => 2,
                'instance' => 'reject'
              }
            },
            'files' => {
              '/var/log/snort/snort.stats' => {
                'collect' => %w[snort-dropped snort-reject],
                'plugin' => 'snortstats',
                'instance' => 'eth0',
                'interval' => 600,
                'time_from' => 5
              }
            }
          }
        end

        it 'overrides defaults' do
          content = <<~EOS
            # Generated by Puppet
            <LoadPlugin tail_csv>
              Globals false
            </LoadPlugin>

            <Plugin "tail_csv">
              <Metric "snort-dropped">
                Type "percent"
                Instance "dropped"
                ValueFrom 1
              </Metric>
              <Metric "snort-reject">
                Type "percent"
                Instance "reject"
                ValueFrom 2
              </Metric>
              <File "/var/log/snort/snort.stats">
                Plugin "snortstats"
                Instance "eth0"
                Collect "snort-dropped"
                Collect "snort-reject"
                Interval 600
                TimeFrom 5
              </File>
            </Plugin>

          EOS

          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_file('tail_csv.load').with(
            content: content,
            path: "#{options[:plugin_conf_dir]}/10-tail_csv.conf"
          )
        end
      end
    end
  end
end
