# decidim-aixd

Provider-agnostic AI features for [Decidim](https://decidim.org). Currently supports summarization via OpenAI, DeepSeek, Anthropic Claude, and Ollama (self-hosted).

## Installation

### 1. Add to your Gemfile

**From RubyGems** (once published):

```ruby
gem "decidim-aixd"
```

**From a local path** (during development):

```ruby
gem "decidim-aixd", path: "path/to/decidim-modules/decidim-aixd"
```

**From GitHub:**

```ruby
gem "decidim-aixd", github: "aixdesign/decidim-module-aixd"
```

Then run:

```sh
bundle install
```

### 2. Configure a provider

Create `config/initializers/decidim_aixd.rb`:

**OpenAI**

```ruby
Decidim::AIXD.configure do |config|
  config.default_provider = :openai
  config.providers = {
    openai: {
      api_key: ENV["OPENAI_API_KEY"],
      model:   "gpt-4o"          # optional, defaults to gpt-4o
    }
  }
end
```

**DeepSeek**

```ruby
Decidim::AIXD.configure do |config|
  config.default_provider = :deepseek
  config.providers = {
    deepseek: {
      api_key:  ENV["DEEPSEEK_API_KEY"],
      uri_base: "https://api.deepseek.com/v1",
      model:    "deepseek-chat"  # required — DeepSeek does not support gpt-4o
    }
  }
end
```

**Anthropic Claude**

```ruby
Decidim::AIXD.configure do |config|
  config.default_provider = :anthropic
  config.providers = {
    anthropic: {
      api_key: ENV["ANTHROPIC_API_KEY"]
    }
  }
end
```

**Ollama (self-hosted)**

```ruby
Decidim::AIXD.configure do |config|
  config.default_provider = :ollama
  config.providers = {
    ollama: {
      base_url: "http://localhost:11434",  # optional, this is the default
      model:    "llama3.2"                 # optional, this is the default
    }
  }
end
```

## Usage

### From Ruby

```ruby
Decidim::AIXD::Summarize.call(text: "Your long text here...") do
  on(:ok)    { |summary| puts summary }
  on(:error) { |msg|     puts "Error: #{msg}" }
end
```

Optional parameters:

```ruby
Decidim::AIXD::Summarize.call(
  text:       "Your long text here...",
  locale:     :ca,          # target language for the summary (default: I18n.locale)
  max_length: 500,          # character cap (default: none)
  prompt:     "Be brief."   # custom instruction prepended to the default prompt
)
```

### Web form

A summarization form is available at `/aixd/summarize` once the engine is mounted.

## Future directions

Once the module is proven and mature, different integration strategies will be considered:

1. **Merge into decidim-ai** — contribute this module's functionality into the core `decidim-ai` gem, subject to community approval.
2. **Keep it separate** — continue developing AI + Design enhancements independently, outside the Decidim core module ecosystem.
3. **Join forces** — identify other modules tackling similar problems and combine efforts.

## Requirements

- Ruby >= 3.0
- Decidim >= 0.28.0, < 0.32.0
