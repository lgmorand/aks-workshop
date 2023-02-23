module Jekyll
  class CollapsibleTagBlock < Liquid::Block

    def render(context)
      @text = super

      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      @parsedText = converter.convert(@text)

      <<~COLLAPSIBLEBLOCK
<div class="collapsible-content-container">
  <button class="toggle-collapsible">Toggle solution</button>
  <div class="collapsible-content">
    #{@parsedText}
  </div>
</div>
      COLLAPSIBLEBLOCK
    end

  end
end

Liquid::Template.register_tag('collapsible', Jekyll::CollapsibleTagBlock)
