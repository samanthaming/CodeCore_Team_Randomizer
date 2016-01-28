require "sinatra"
require "sinatra/reloader"

use Rack::MethodOverride
enable :sessions

get '/' do
  @names
  erb :index, layout: :application
end


post '/' do
  @name = params[:name]
  @method = params[:method]
  @number = params[:number]

  num_int = @number.to_i

  if @name.empty? || !@method || @number.empty?
    session[:warning] = "You must fill in all fields"
    redirect back
  end

  shuffled_names =  @name.split(/,\s*/).shuffle

  if @method === "per_team"
    ## Per Team
    @names ||= []
    shuffled_names.each_slice(num_int) {|a| @names << a}
    @perteam = "checked"
  else
    ## Team Count
    @names ||= Array.new(num_int) { Array.new }
    while(shuffled_names.length > 0)
        num_int.times do |i|
            @names[i] << shuffled_names.shift
        end
    end
    @teamcount = "checked"
  end

  session[:warning] = nil
  erb :index, layout: :application
end

delete "/reset" do

end
