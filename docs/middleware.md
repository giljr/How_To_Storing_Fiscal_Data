
🆕 Nov 2025 — Added a custom `MyCustomLogger` middleware
Introduced a new middleware located in `app/middleware/` and inserted it properly into the Rails stack. This component powers a metrics dashboard that measures the elapsed time between when an API command is received and when the final file is delivered. 

🎊 You should see in Terminal:

```ruby
⏱ RCAD Middleware Time: 446.44 ms
```

#### For details read:
---

# Middleware

A middleware in Rails is a small component that sits between the web server and your Rails application, intercepting every request and response. It can __log data__, __modify headers__, __handle authentication__, __measure performance__, or __block requests__ before they reach your controllers. It's ideal for cross-cutting concerns that apply to the entire app.


__To Create__ your custom middleware `MyCustomLogger` from `app/middleware/` and insert it into the Rails stack the right way.

This version is clean, safe, and matches Rails 8 conventions.

### Let's Get Started!

0️⃣ Directory structure:
```
/app/middleware
   my_custom_logger.rb   
```

1️⃣ Updated `config/application.rb`
```ruby
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module RcadApp
  class Application < Rails::Application
    config.load_defaults 8.0

    config.rcad_path = {
      original:    Rails.root.join("rcad_files/original"),
      processados: Rails.root.join("rcad_files/processados"),
      erros:       Rails.root.join("rcad_files/erros")
    }

    # Add custom dir to autoload
    config.autoload_paths << Rails.root.join("app/middleware")

    # Load middleware class BEFORE inserting
    require Rails.root.join("app/middleware/my_custom_logger")

    # Insert middleware
    config.middleware.insert_before 0, MyCustomLogger

  end
end

```
 What you must have in your project:

2️⃣ Create this file:

`app/middleware/my_custom_logger.rb`
```ruby
# app/middleware/my_custom_logger.rb

class MyCustomLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    status, headers, body = @app.call(env)

    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration = ((finish - start) * 1000).round(2)

    Rails.logger.info "⏱ RCAD Middleware Time: #{duration} ms"

    [status, headers, body]
  end
end
```
3️⃣ Restart the server

```bash
bin/dev
```
4️⃣ Test the middleware

```bash
curl -X POST http://localhost:3000/api/v1/rcad/processar
```

5️⃣ Then:

```bash
tail -f log/development.log
```
🎊 You should see:

```ruby
⏱ RCAD Middleware Time: 446.44 ms
```

Here is a clear explanation of what each line does:

1. Add custom dir to autoload
```ruby
config.autoload_paths << Rails.root.join("app/middleware")
```
Rails automatically loads classes from certain folders (like `app/models`, `app/controllers`, etc.).
But `app/middleware` is not autoloaded by default.

This line tells Rails:

“Also look inside app/middleware when searching for classes.”

So Rails can autoload your custom middleware class if needed.


2. Load middleware class BEFORE inserting
```
require Rails.root.join("app/middleware/my_custom_logger")
```
Normally Rails autoloads files lazily, but middleware must be loaded at boot time, before the middleware stack is built.

This require ensures the file is loaded immediately so the `class MyCustomLogger` exists when Rails tries to insert it into the stack.

Without this, Rails may throw:
```error
uninitialized constant MyCustomLogger
```

3. Insert middleware
```
config.middleware.insert_before 0, MyCustomLogger
```
Rails middleware is a stack.
insert_before 0 means:

“Put this middleware at the very top (first position) of the stack.”

This makes your MyCustomLogger middleware run before every other middleware.

So your logger will capture:

- the start of the request

- the end of the request

 - the total time

- anything else you add

before any other framework component touches the request.

#### Summary

`autoload_paths`: Tells Rails to look inside app/middleware.

`require`: Ensures the class is loaded early, because middleware cannot be lazy-loaded.

`insert_before 0`: Adds your custom middleware as the first middleware in the chain.

---


                                  ⋆.˚✮𝕋𝕙𝕒𝕟𝕜 𝕪𝕠𝕦✮˚.⋆
