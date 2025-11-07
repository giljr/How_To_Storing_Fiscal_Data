# RCAD File Loading Techniques

This guide explains refined techniques for loading **RCAD files** efficiently and safely.  
It’s based on real-world experience — tested for over a year — and inspired by the work of a senior developer, **Jeovan**.

By following these techniques, you’ll write more **professional, maintainable, and robust** loaders that save both time and effort.

---

## ✅ What Defines a Good Fiscal File Loader?

A well-designed loader should be:

- Easy to maintain and extend  
- Resilient to malformed or inconsistent data  
- Clear in its error messages and transaction handling  
- Clean, **DRY**, and **Ruby-idiomatic**

These characteristics took time to refine, but they define a best-practice approach to reliable RCAD data importation.

The [enhanced](https://www.diffchecker.com/RqsUMfAZ/) version introduces improvements in structure, safety, and maintainability.  
It also employs **metaprogramming** and a **data-driven architecture**, making it flexible yet disciplined.

---

## 🧩 1. Structure and Maintainability

| Aspect                | Enhanced                                                                          | Verdict                                                 |
| --------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **Code Organization** | Extracted helper methods (`inicializar_colecoes`, `log_erro`, `processar_mestre`) | ✅ Enhanced is **modular** and far more **maintainable** |
| **Duplication**       | Uses a **hash map** (`@colecoes`) to dynamically manage all record types          | ✅ Enhanced avoids duplication, easier to extend         |
| **Scalability**       | Just add a new entry to `@colecoes`                                               | ✅ Enhanced scales elegantly                             |

---

## ⚙️ 2. Safety and Error Handling

| Aspect                         | Enhanced                                                                           | Verdict                                                       |
| ------------------------------ | ---------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| **Error Handling Granularity** | Each line inside `each_line` has its own `begin/rescue` for granular rollback info | ✅ Enhanced provides **fine-grained error logging**            |
| **Error Logging**              | Centralized `log_erro` method (cleaner logging, consistent messages)               | ✅ Enhanced improves readability and consistency               |
| **Rollback Control**           | Same rollback logic, but scoped with better logging                                | ➖ Both rollback correctly, but Enhanced explains “why” better |

---

## 🧾 3. File and Encoding Handling

| Aspect             | Enhanced                                                 | Verdict                                                                  |
| ------------------ | -------------------------------------------------------- | ------------------------------------------------------------------------ |
| **File Encoding**  | Opens files explicitly and stores path in `arquivo_path` | ✅ Enhanced is cleaner, less error-prone                                  |
| **File Filtering** | Proper `.TXT` filter using `end_with?(".TXT")`           | ✅ Enhanced avoids processing non-text files                              |
| **File Movement**  | Moves using `arquivo_path`, ensuring reliability         | ✅ Enhanced fixes a **potential bug** (original may move wrong reference) |

---

## 🧮 4. Data Processing

| Aspect                  | Enhanced                                       | Verdict                                                      |
| ----------------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| **Line Identification** | Uses pipe-delimited logic `row.split(' \| ')[1]` with a guard | ✅ Enhanced is **more robust** and handles variable formats |
| **Master Record**       | Uses `processar_mestre(row, arquivo_original)` | ➖ Equivalent but **naming improved**                         |
| **Batch Import**        | Iterates dynamically over `@colecoes`          | ✅ Enhanced simplifies imports and reduces maintenance effort |

---

## 💡 5. Readability and Style

| Aspect                 | Enhanced                                            | Verdict                                     |
| ---------------------- | --------------------------------------------------- | ------------------------------------------- |
| **Readability**        | Compact, expressive, and Ruby-idiomatic             | ✅ Enhanced clearly superior                 |
| **Naming Conventions** | Consistent mapping between type → class → method    | ✅ Enhanced follows better naming discipline |
| **Spinner Feedback**   | Same spinner logic but errors go through `log_erro` | ➖ Both fine, but Enhanced cleaner           |

---

## ⚡ Summary

| Category        | Winner     | Key Improvement                                             |
| --------------- | ---------- | ----------------------------------------------------------- |
| **Maintainability** | ✅ Enhanced | Modular design with `@colecoes`                             |
| **Error Handling**  | ✅ Enhanced | Line-level rescue and unified logging                       |
| **File Handling**   | ✅ Enhanced | Safer and more explicit file operations                     |
| **Robustness**      | ✅ Enhanced | Handles encoding, file filtering, and record parsing better |
| **Performance**     | ⚖️ Tie     | Both use `activerecord-import` effectively                  |

The enhanced implementation is clearly superior:

- Easier to maintain and extend  
- More robust against malformed data  
- Clearer error messages and transaction control  
- Clean, DRY, and Ruby-idiomatic

---

## 🧩 Understanding `batch_size: 10_000`

When calling:

```ruby
Cliente.import(clientes, validate: false, batch_size: 10_000)
```
#### Why use batching?

Because inserting millions of records in one SQL statement could:
```text
exceed your database’s packet or SQL statement limit,

consume too much memory, or

degrade performance.
```
#### What the log shows
```ruby
Cliente Create Many (1.7ms) INSERT INTO "clientes" (...) VALUES (...), (...), (...)
```

That’s a bulk insert generated by activerecord-import, inserting up to 10,000 rows per query — extremely fast and efficient.

| Option       | Source                      | Meaning                                   | Result                                             |
| ------------ | --------------------------- | ----------------------------------------- | -------------------------------------------------- |
| `batch_size` | `activerecord-import`       | Number of records per bulk SQL insert     | 10,000 rows per batch                              |
| Log message  | Rails / ActiveRecord logger | Shows each batch insert operation         | `INSERT INTO "clientes" (...) VALUES (...), (...)` |
| Benefit      | Performance                 | Much faster than individual `.save` calls | ✔️ Efficient bulk inserts                          |

## 🧩 Structural Recap

The `@colecoes` variable acts as a dynamic registry — a Ruby-style metaprogramming pattern that generalizes logic across many record types without conditionals.
```ruby
@colecoes = { 
  "B" => { lista: [], metodo: :cliente, classe: Cliente },
  "C" => { lista: [], metodo: :pedido,  classe: Pedido },
  # ...
}
```

Each key ("B", "C", etc.) represents a record type, and each value defines how to handle it:

:metodo → method to parse or build the record

:classe → corresponding ActiveRecord model

:lista → temporary buffer for objects built

## ⚙️ How It Works

#### Initialization

`inicializar_colecoes` sets up the `@colecoes` hash with empty arrays.

#### File Iteration
```ruby
arquivo.each_line.with_index do |row, index|
  tipo = row.start_with?("|") ? row.split("|")[1] : nil
```
Determines the record type based on the second field.

#### Dynamic Dispatch
```ruby
if @colecoes.key?(tipo)
  objeto = send(@colecoes[tipo][:metodo], row)
  @colecoes[tipo][:lista] << objeto
end
```

#### Bulk Import
```ruby
@colecoes.each_value do |col|
  col[:classe].import(col[:lista], validate: false, batch_size: 10_000)
end
```
## 🧠 Conceptual Summary

This design replaces a long chain of if/elsif conditions with a clean, extensible structure:

| Type | Parse Method | Model Class | Purpose        |
| ---- | ------------ | ----------- | -------------- |
| "B"  | `:cliente`   | `Cliente`   | Client records |
| "C"  | `:meio_de_capturas`    | `meio_de_capturas`    | Order P.O.  |
| ...  | ...          | ...         | ...            |


To add a new record type, simply register a new entry in @colecoes.
No need to modify the core processing loop.

### ✅ In Short

This architecture is data-driven:

The file defines what to process

The @colecoes hash maps record types to behavior

The code remains generic, DRY, and extensible

## 💎 Two Fantastic Ruby Tools: send and import

### 1️⃣ send
```ruby
objeto = send(@colecoes[tipo][:metodo], row)
```

`Purpose:` Dynamically call a method by name — even if you don’t know it at coding time.
Origin: Ruby’s Object class.

Equivalent to:
```ruby
cliente(row) # if :metodo == :cliente
meio_de_capturas(row)  # if :metodo == :meio_de_capturas
```
### 2️⃣ import
```ruby
col[:classe].import(col[:lista], validate: false, batch_size: 10_000)
```

`Purpose:` Efficiently bulk insert records using the activerecord-import gem.
Origin: Extension of `ActiveRecord::Base`.

| Method   | Origin / Class                                       | Purpose                              | Example                                        |
| -------- | ---------------------------------------------------- | ------------------------------------ | ---------------------------------------------- |
| `send`   | `Object` (core Ruby)                                 | Dynamically call a method by name    | `send(:parse_cliente, row)`                    |
| `import` | `ActiveRecord::Base` (via `activerecord-import` gem) | Bulk insert many records efficiently | `Cliente.import(clientes, batch_size: 10_000)` |

### Curiosity:
The difference between `row.chomp` and `row.chomp!` in Ruby is subtle but important 👇

| Expression             | Returns                                       | Modifies original?                    | Typical Use                                               |
| ---------------------- | --------------------------------------------- | ------------------------------------- | --------------------------------------------------------- |
| `row_data = row.chomp` | **A new string** with the line ending removed | ❌ **No** — `row` stays unchanged      | When you want to keep the original intact                 |
| `row.chomp!`           | The **same string**, modified in place        | ✅ **Yes** — `row` is changed directly | When you want to save memory or update the value in place |

__Summary__

`chomp` → safe, returns a new string.

`chomp!` → destructive, modifies the existing string (and returns nil if no change was made).

So, use:

`chomp` when you want immutability and clarity.

`chomp!` when performance or memory efficiency matters.

### 💬 Final Thoughts

This enhanced implementation is the result of hands-on experience.
It demonstrates that practical refinements come from iteration, not theory.

As a team, we should value and share what’s born from experience — because it leads to cleaner, safer, and smarter code.

#### Happy coding!
