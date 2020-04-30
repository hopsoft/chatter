# frozen_string_literal: true

class PostsReflex < ApplicationReflex
  include CableReady::Broadcaster

  def repost
    post = Post.find(element.dataset[:id])
    post.increment! :reposts_count
    cable_ready["timeline"].text_content(
      selector: "#post-#{post.id}-reposts",
      text: post.reposts_count
    )
    cable_ready.broadcast
  end

  def like
    post = Post.find(element.dataset[:id])
    post.increment! :likes_count
    cable_ready["timeline"].text_content(
      selector: "#post-#{post.id}-likes",
      text: post.likes_count
    )
    cable_ready.broadcast
  end
end
