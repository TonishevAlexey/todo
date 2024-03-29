require_relative './db/database'
require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/contrib'
require 'rack/contrib'

class TodoApp < Sinatra::Base
  use Rack::MethodOverride
  set :database_file, "config/database.yml"

  get '/' do
    redirect to '/posts'
  end

  get '/posts' do
    @todos = Post.all
    erb :'posts/index'
  end

  get '/posts/new' do
    erb :'posts/new'
  end
  post '/posts' do
    params.delete 'submit'
    @todo = Post.create(params)
    if @todo.save
      redirect to '/posts'
    else
      'Post was not save'
    end
  end
  get '/posts/:id' do
    @todo = Post.get(params[:id])
    erb :'posts/edit'
  end

  patch '/posts/:id' do
    params.delete 'submit'
    todo = Post.get(params[:id])
    todo.title = (params[:title])
    todo.body = (params[:body])
    todo.save
    redirect '/posts'
  end

  delete '/posts/:id' do
    params.delete 'submit'

    Post.get(params[:id]).destroy
    redirect '/posts'
  end
end