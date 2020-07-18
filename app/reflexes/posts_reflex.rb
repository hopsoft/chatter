# frozen_string_literal: true

class PostsReflex < ApplicationReflex
  include CableReady::Broadcaster

  def repost
    post = Post.find(element.dataset[:id])
    post.increment! :reposts_count
    selector = "#post-#{post.id}-reposts"

    # --------------------------------------------------------------------------
    # morph :nothing
    #
    # What happens?
    # - does not re-render the page
    # - does not send new HTML over the wire
    #
    # Why use it?
    # - skip view template rendering
    # - no ui updates
    # - lightning fast

    # --------------------------------------------------------------------------
    # morph selector, post.reposts_count
    #
    # What happens?
    # - does not re-render the page
    # - sends simple primitive values (text, numbers, etc...) over the wire
    #
    # Why use it?
    # - skip view template rendering
    # - surgical micro updates
    # - tiny payload over the wire
    # - very fast

    # --------------------------------------------------------------------------
    # morph selector, "<span id='#{selector[1,-1]}'>#{post.reposts_count}</span>"
    #
    # What happens?
    # - does not re-render the page
    # - sends smaller HTML strings over the wire
    #
    # Why use it?
    # - take control of the view template rendering
    # - smaller updates (think sections of the page)
    # - smaller payload over the wire
    # - fast

    cable_ready["timeline"].text_content(
      selector: selector,
      text: post.reposts_count
    )
    cable_ready.broadcast
  end

  def like
    post = Post.find(element.dataset[:id])
    post.increment! :likes_count
    selector = "#post-#{post.id}-likes"
    # morph :nothing
    # morph selector, post.reposts_count
    # morph selector, "<span id='#{selector[1,-1]}'>#{post.reposts_count}</span>"
    cable_ready["timeline"].text_content(
      selector: selector,
      text: post.likes_count
    )
    cable_ready.broadcast
  end
end
