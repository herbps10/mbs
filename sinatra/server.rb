require 'rubygems'

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'haml'

def rScript(name)
	return '/home/hps1/vaccines/' + name
end

helpers do
	def inputPartial(i)
		haml :input, {:layout => false, :locals => {:input => i}}
	end
end

class Input
	attr_accessor :name, :label, :type, :value, :rparameter

	def initialize(name, label, type, value, rparameter = true)
		@name = name
		@label = label
		@type = type
		@value = value
		@rparameter = rparameter
	end
end

$inputs = [
	Input.new("populationsize", "Population Size", "text", 100),
	Input.new("infectious", "Initial Infectious", "text", 1),
	Input.new("unvaccinated", "Initial Unvaccinated", "text", 20),
	Input.new("frames", "Number of Animation Frames", "text", 100),
	Input.new("animation", "Make Animation", "checkbox", true),
	Input.new("datafile", "Make Data File", "checkbox", true)
]

get '/' do
	@inputs = $inputs

	haml :index
end

get '/generate' do
	rpath = rScript("web.r")

	$inputs.each do |input|
		next if input.rparameter == false

		val = params[input.name]
		val = "" if val == "on" or val == nil

		rpath += " --" + input.name + " " + val
	end
	
	system("Rscript " + rpath + " > /home/hps1/vaccines/output &")

	haml :generate
end

get '/status' do
	if params['job'] == 'generate'
		res = `tail -n 1 /home/hps1/vaccines/output`.chomp.strip
		res = 0.to_s if res == ""

		res
	end
end
