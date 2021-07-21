require_relative 'version'
require 'fileutils'

PATH = Gem::path[1]+"/gems/m4dh4v45b1n-#{VERSION}/db"

module FcError
  class NoContainerSelected < StandardError;end
  class ContainerExist < StandardError;end
  class ContainerNotExist < StandardError;end
end

class Fcontainer
  attr_accessor :container, :child, :element, :values
  def initialize()
  end
  def create_containers(name)
    @container = PATH + "/#{name}"
    if !File.exist? @container
      Dir::mkdir(@container)
      return name
    else
      raise FcError::ContainerExist::new("Create New Insted or Delete #{name}")
    end
  end
  def create_chain_child_container(children)
    if !@container.nil?
      tmp_child = @container
      children.map do |d|
        tmp_child += "/#{d}"
        Dir::mkdir(tmp_child)
      end
      return children
    else
      raise FcError::NoContainerSelected::new("Where is the container ?")
    end
  end
  def create_child_container(child_list, new)
    if !@container.nil?
      tmp_child = @container
      children.map do |d|
        tmp_child += "/#{d}"
      end
      if File.exist? tmp_child
        Dir::mkdir(tmp_child+"/#{new}")
      else
        raise FcError::ChildNotExist::new(child_list.to_s)
      end
      return children
    else
      raise FcError::NoContainerSelected::new("Where is the container ?")
    end
  end
  def open_container(container)
    @container = PATH + "/#{container}"
    if File.exist? @container
      return container
    else
      raise FcError::ContainerNotExist::new("Which container ?")
    end
  end
  def delete_child_container(delete_child)
    tmp_cont = @container
    if File.exist? tmp_cont
      delete_child.map do |c|
        tmp_cont += "/#{c}"
      end
      if File.exist? tmp_cont
        FileUtils::rm_r tmp_cont
      else
        raise FcError::ChildNotExist::new("which child ?")
      end
    else
      raise FcError::ContainerNotExist::new("Which container ?")
    end
  end
  def open_child(child)
    tmp_
  end
end
