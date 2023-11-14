require "google_drive"

session = GoogleDrive::Session.from_config("config.json")
spreadsheet = session.spreadsheet_by_key("1rwfAax11xRiqGEoKELU42pneJMoY-8fDmiIlVSXOcH8")
worksheet = spreadsheet.worksheets[0]
tabela_niz = worksheet.rows

class Tabela

  include Enumerable

  def initialize(tabela)
    @t = tabela
  end

  def row(row)
    @t[row-1]
  end

  def each
    @t.each do |row|
      row.each do |n|
        yield n
      end
    end
  end

  def [] (kolona)
    k = @t.first.index(kolona)
    raise "Kolona ne postoji" unless k

    @t.drop(1).map{ |row| row[k]}
  end

end

tabela = Tabela.new(tabela_niz)

# tabela.each do |n|
#   p n
# end

p tabela["Prva Kolona"]
