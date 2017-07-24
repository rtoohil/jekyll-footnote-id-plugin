require 'digest'

module MarkdownFootnoteID
  
  class FootnoteID < Jekyll::Generator
    safe true
    priority :normal
    
    def generate(site)
      md5 = Digest::MD5.new
      
      site.posts.docs.each do |p|
        # Get our array of footnote matches
        footnotes = find_markdown_footnotes(p)
  
        # Is our array empty?
        unless footnotes.empty?
          # For each footnote reference, let's create our new reference string
          # then update the old footnote references with it
          footnotes.each_with_index do |note, index|
            fn_ref = note[0].to_s + '-' + index.to_s + '-' + md5.hexdigest(p.path) 
            update_footnote_references!(p, note[0].to_s, fn_ref)
            update_footnote!(p, note[0].to_s, fn_ref)
          end
        end
      end
    end  
    
    private
    def find_markdown_footnotes(post)
      # Let's match all the footnote refs, but not the footnotes themselves
      post.content.scan(/\[\^(\S*?)\][^\:]/)
    end
    
    def update_footnote_references!(post, old_fn_ref, new_fn_ref)
      # Let's replace the footnote references
      post.content.gsub!(/\[\^#{old_fn_ref}\][^\:]/, "[^#{new_fn_ref}]")
    end
    
    def update_footnote!(post, old_fn_ref, new_fn_ref)
      # Let's replace the footnotes themselves
      post.content.gsub!(/\[\^#{old_fn_ref}\]:/, "[^#{new_fn_ref}]:")
    end
  
  end
  
end
