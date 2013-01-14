# Copyright 2013, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Attrib < ActiveRecord::Base
  
  before_create :must_have_barclamp
  
  attr_accessible :name, :description, :order, :barclamp_id, :hint

  validates_format_of     :name, :with=>/^[a-zA-Z][_a-zA-Z0-9]*$/, :message => I18n.t("db.lettersnumbers", :default=>"Name limited to [_a-zA-Z0-9]")
  validates_uniqueness_of :name, :case_sensitive => false, :message => I18n.t("db.notunique", :default=>"Name item must be unique")

  has_many   :node_attribs, :dependent => :destroy
  has_many   :nodes, :through=>:node_attribs
  belongs_to :barclamp
  
  private
  
  # make sure attribute has a barclamp
  def must_have_barclamp
    if self.barclamp_id.nil?
      cb = Barclamp.find_by_name('crowbar')
      throw "Attrib create failed because we do not have a Crowbar barclamp" if cb.nil?
      self.barclamp_id = cb.id
    end
  end
  
end

