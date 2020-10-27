ThinkingSphinx::Index.define :course, :with => :real_time do
    indexes title, :sortable => true
    indexes serial, :sortable => true
    
    has semster,  :type => :integer
  end