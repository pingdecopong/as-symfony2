#
# Cookbook Name:: as_symfony2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'as-apache2::default'
include_recipe 'as-php::default'
include_recipe 'as-symfony2::create'
