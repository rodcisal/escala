require 'rubygems'
require 'newrelic_rpm'
require 'sinatra'
require 'axlsx'

module Rack
  class Request
    def ip
      if addr = @env['HTTP_X_FORWARDED_FOR']
        addr.split(',').last.strip
      else
        @env['REMOTE_ADDR']
      end
    end
  end
end

class Array
  def chunk(size=2)
    chunks = []
    start = 0
    1.upto((self.length/size).ceil+1) do |i|
      last = start+size-1
      chunks << self[start..last] unless self[start..last].empty?
      start = last+1
    end
    chunks
  end
end

get '' do
redirect 'escala/'
end

get '/' do
  @notas = listado_notas(params).chunk(10)
  params[:exig] = params[:exig]*100
  erb :escala
end

get '/planilla.xlsx' do
  notas = listado_notas(params)

  p = Axlsx::Package.new
  wb = p.workbook
  wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
    sheet.add_row ["Nota", "Puntaje"]
    notas.each_with_index do |n, i|
      celda = "A#{i+2}"
      sheet.add_row [n.first, "=ROUND(TRUNC(IF(#{celda}<#{params[:exig]*params[:pmax]},#{params[:napr]-params[:nmin]}*#{celda}/#{params[:exig]*params[:pmax]}+#{params[:nmin]},#{params[:nmax]-params[:napr]}*(#{celda}-#{params[:exig]*params[:pmax]})/#{params[:pmax]*(1-params[:exig])}+#{params[:napr]}),2),1)"] #(n.last*10).round/10.0]
    end
  end

  content_type 'application/octet-stream'
  p.to_stream

end

private

def nota(ptje) 
  if(ptje<params[:exig]*params[:pmax])
    nota=(params[:napr]-params[:nmin])*ptje/(params[:exig]*params[:pmax])+params[:nmin] 
  else
    nota=(params[:nmax]-params[:napr])*(ptje-params[:exig]*params[:pmax])/(params[:pmax]*(1-params[:exig]))+params[:napr]
  end
  return nota
end

def listado_notas(params)
  default_params = {:exig => 60 , :pmax => 100, :paso => 1, :nmin => 2, :nmax => 7, :napr => 4, :orden => 'ascendente'}
  default_params.each{|k,v| params[k] = v if (!params[k] or params[k].empty?)}
  params.each{|k,v| params[k]=v.to_s.gsub(",",".").to_f unless k == "orden" or k == :orden}
  params[:exig] = params[:exig]/100.0
  params[:pmax] = 1000 if params[:pmax] > 1000
  params[:pmax] = 10 if params[:pmax] <= 0
  params[:paso] = 1.0 if params[:paso] == 0
  params[:paso] = 0.01 if params[:paso] < 0.01
  @notas = (0..params[:pmax]/params[:paso]).map{|p| [(p*params[:paso]).round(2),nota(p*params[:paso])]}
  @notas.reverse! if params[:orden] == 'descendente'
  return @notas
end