require "google_drive"

session = GoogleDrive::Session.from_config("config.json")
spreadsheet = session.spreadsheet_by_key("1rwfAax11xRiqGEoKELU42pneJMoY-8fDmiIlVSXOcH8")
worksheet = spreadsheet.worksheets[0]
dvodimenzionalni_niz = worksheet.rows

class Tabela

  include Enumerable

  def initialize(table_data)
    @vrednosti = table_data
  end

  def row(row_number)
    @vrednosti[row_number - 1]
  end

  def each
    @vrednosti.each do |red|
      red.each do |element|
        yield element
      end
    end
  end

end

tabela = Tabela.new(dvodimenzionalni_niz)

tabela.each do |element|
  p element
end
