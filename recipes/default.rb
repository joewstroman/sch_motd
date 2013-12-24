#
# Cookbook Name:: motd
# Recipe:: default
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
directory '/etc/update-motd.d' do
	mode 00644
	group 'root'
	owner 'root'
end

file '/etc/motd' do
	owner	'root'
	group	'root'
	mode	'0744'
	action	:create
end

include_recipe 'sch_motd::cow'
include_recipe 'sch_motd::knife-status'
include_recipe 'sch_motd::chef-fail'

cron 'update motd' do
	action	:create
	minute	"*/1"
	command "rm -rf /etc/motd ; for i in $(ls -1 /etc/update-motd.d/* | sort -V) ; do $i >> /etc/motd ; done"
end