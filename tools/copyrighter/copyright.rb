require_relative 'copyright_param'

class Copyright

  attr_reader :text, :params

  def initialize(text)

    @text = text
    @params = []

  end

  def add_param(param)
    @params.push param
  end

  def set_param(name, value)

    @params.each do |param|
      if name == param.name
        param.value = value
        return
      end
    end

    add_param CopyrightParam.new(name, value)

  end

  def process

    new_text = text

    @params.each do |param|
      name = param.decorated_name
      value = param.value

      new_text.sub! name, value

    end

    return new_text

  end

end