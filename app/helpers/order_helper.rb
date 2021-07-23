module OrderHelper
  def self.generate_code
    length = 6
    source = [*('A'..'Z'), *('0'..'9')]

    begin
      code = source.sample(length).join
    end while Order.where(code: code).any?

    return code
  end
end
