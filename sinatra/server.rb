require 'rubygems'

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'haml'
require 'find'

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

$inputs = {
	"populationsize" 	=> Input.new("populationsize", "Population Size", "text", 100),
	"infectious" 		=> Input.new("infectious", "Initial Infectious", "text", 1),
	"unvaccinated" 		=> Input.new("unvaccinated", "Initial Unvaccinated", "text", 20),

	"infectionlength" 	=> Input.new("infectionlength", "Length of Infection", "text", 10), "recoverylength" 	=> Input.new("recoverylength", "Length of Recovery", "text", 10), "timetoinfect" 		=> Input.new("timetoinfect", "Latency Period", "text", 4),

	"frames" 		=> Input.new("frames", "Time Steps", "text", 100),

	"animation" 		=> Input.new("animation", "Make Animation", "checkbox", true),
	"datafile" 		=> Input.new("datafile", "Make Data File", "checkbox", true),

	"graph"			=> Input.new("graph", "Graph Generator", "text", 0), # This isn't actually used for form generation, because it's a select box so the behaviour is a little more complex. This is just used for automatic form handling.

	"simulations"		=> Input.new("simulations", "Number of Simulations", "text", 10, false),
	"cluster"		=> Input.new("cluster", "Use Cluster", "checkbox", true, false),
}

$graphGenerators = []
Find.find("/home/hps1/vaccines/graph_generators/") do |path|
	next if FileTest.directory? path
	$graphGenerators.push path
end

get '/' do
	@view = "index"
	haml :index
end

post '/generate' do
	rpath = rScript("web.r")

	$inputs.each_value do |input|
		next if input.rparameter == false

		val = params["generate"][input.name]
		val = "" if val == "on" or val == nil

		rpath += " --" + input.name + " " + val
	end

	system("Rscript " + rpath + " > /home/hps1/vaccines/output &")
	
	@view = "generate"
	haml :generate
end

get '/one' do
	@inputs = $inputs
	
	@graphGenerators = $graphGenerators

	@view = 'one'
	haml :one
end

get '/many' do
	@inputs = $inputs

	@view = "many"
	haml :many
end

get '/complete' do
	haml :complete
end

get '/status' do
	if params['job'] == 'generate'
		res = `tail -n 1 /home/hps1/vaccines/output`.chomp.strip
		res = 0.to_s if res == ""

		res
	end
end
