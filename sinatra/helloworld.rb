require 'rubygems'

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'haml'

def rScript(name)
	return '/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/' + name
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
	Input.new("animationframes", "Number of Animation Frames", "text", 100),
	Input.new("animation", "Make Animation", "checkbox", true, false),
	Input.new("datafile", "Make Data File", "checkbox", true)
]

get '/' do
	@inputs = $inputs

	haml :index
end

get '/generate' do

	rpath = rScript("animate.r")

	$inputs.each do |input|
		next if input.rparameter == false

		val = params[input.name]
		val = "off" if val == nil

		rpath += " --" + input.name + " " + val
	end

	rpath

	system("Rscript " + rpath)

	#haml :generate
end
