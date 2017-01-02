class CssClasses < Array
  def initialize(*classes)
    self << classes
  end

  def <<(classes)
    if classes.is_a?(String)
      classes.split(" ").each { |c| super(c) }
    elsif classes.is_a?(Array)
      classes.flatten.compact.each { |c| self << c }
    elsif classes.is_a?(Symbol)
      self << classes.to_s
    end
  end

  def to_s
    to_a.join(" ").presence
  end
end
