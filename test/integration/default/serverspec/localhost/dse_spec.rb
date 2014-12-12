require 'spec_helper'

describe service('dse') do  
  it { should be_enabled   }
  it { should be_running   }
end  
