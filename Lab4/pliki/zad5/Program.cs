namespace MateuszLopacinskiEFProducts
{
  class Program
  {
    public const string ADD = "add";              // Add a new product
    public const string REMOVE = "remove";        // Remove a product
    public const string SELL = "sell";            // Sell products
    public const string ALL = "all";              // Display all products
    public const string AVAIALBLE = "available";  // Display available products
    public const string EXIT = "exit";            // Exit

    public static List<string> ALL_CMDS = new() {
            ADD, REMOVE, SELL, ALL, AVAIALBLE, EXIT
        };

    static void Main()
    {
      using ShopContext shopContext = new();

      bool exited = false;
      while (!exited)
      {
        switch (GetCommand())
        {
          case ADD:
            AddNewProduct(shopContext);
            break;
          case REMOVE:
            RemoveProduct(shopContext);
            break;
          case SELL:
            SellProduct(shopContext);
            break;
          case ALL:
            DisplayAllProducts(shopContext);
            break;
          case AVAIALBLE:
            DisplayAvailableProducts(shopContext);
            break;
          case EXIT:
            exited = true;
            Console.WriteLine("To dzisiaj na tyle, dzięki za współpracę");
            break;
          default:
            Console.WriteLine("Polecenie nie zostało rozpoznane, spróbuj jeszcze raz.");
            break;
        }
        Console.WriteLine();
      }
    }

    private static string GetCommand()
    {
      Console.WriteLine("Napisz, co chcesz zrobić. Lista dostępnych komend:");
      DisplayAvailableCommands();
      Console.Write(">>> ");
      return Console.ReadLine();
    }

    private static void AddNewProduct(ShopContext shopContext)
    {
      Product product = CreateNewProduct();
      Console.WriteLine("Zapisuję produkt do bazy danych...");
      shopContext.Products.Add(product);
      shopContext.SaveChanges();
    }

    private static void SellProduct(ShopContext shopContext)
    {
      List<InvoiceItem> items = ChooseInvoiceItems(shopContext);
      Console.WriteLine("Aktualizuję liczbę dostępnych produktów...");
      foreach (InvoiceItem item in items)
      {
        item.Product.UnitsInStock -= item.Quantity;
        Console.WriteLine($"Pozostało {item.Product.UnitsInStock} szt. {item.Product.ProductName}");
      }

      Invoice invoice = CreateInvoice(items);
      shopContext.Invoices.Add(invoice);
      shopContext.SaveChanges();
    }

    private static void RemoveProduct(ShopContext shopContext)
    {
      Console.WriteLine("Lista wszystkich produktów:");
      DisplayAllProducts(shopContext);
      Console.Write("Podaj id produktu do usunięcia\n>>> ");
      int id = Int32.Parse(Console.ReadLine());

      var query = from product in shopContext.Products
                  where product.ProductID == id
                  select product;

      if (query?.Count() > 0)
      {
        shopContext.Remove(query.First());
        shopContext.SaveChanges();
        Console.WriteLine("Produkt został pomyślnie usunięty");
      }
      else
      {
        Console.WriteLine($"Nie można usunąć produktu. Produkt o id równym {id} nie istnieje");
      }
    }

    private static Invoice CreateInvoice(List<InvoiceItem> items)
    {
      return new Invoice
      {
        InvoiceItems = items
      };
    }

    private static Product CreateNewProduct()
    {
      Console.Write("Podaj nazwę produktu\n>>> ");
      string prodName = Console.ReadLine();
      Console.Write("Podaj liczbę dostępnych sztuk produktu\n>>> ");
      int quantity = Int32.Parse(Console.ReadLine());

      Console.WriteLine("Tworzę nowy produkt...");
      Product product = new()
      {
        ProductName = prodName,
        UnitsInStock = quantity
      };
      Console.WriteLine($"Stworzono produkt: {product}");
      return product;
    }

    private static List<InvoiceItem> ChooseInvoiceItems(ShopContext shopContext)
    {
      Console.WriteLine("Z poniższej listy wybierz produkty, które mają zostać dodane do faktury");
      Console.WriteLine("- wprowadź id produktu, a po spacji liczbę sprzedawanych sztuk");
      Console.WriteLine("- aby zakończyć wybieranie produktów, naciśniej Enter\n");
      DisplayAvailableProducts(shopContext);

      Dictionary<Product, int> addedItems = new();

      while (true)
      {
        Console.Write("\n>>> ");
        string input = Console.ReadLine();

        if (input == String.Empty)
        {
          Console.WriteLine("Zakończono wybieranie produktów");
          break;
        }
        else
        {
          string[] splitted = input.Split();
          int id = Int32.Parse(splitted[0]);
          int quantity = Int32.Parse(splitted[1]);

          Product product = shopContext.Products.First(p => p.ProductID == id);
          int newQuantity = quantity + (addedItems.ContainsKey(product) ? addedItems[product] : 0);
          if (newQuantity > product.UnitsInStock)
          {
            Console.WriteLine($"Nie można dodać {product.ProductName}. Dostępnych jest tylko {product.UnitsInStock} szt.");
          }
          else
          {
            Console.WriteLine($"Dodano {quantity} szt. {product.ProductName} do faktury. Razem na fakturze jest {newQuantity} szt.");
            if (addedItems.ContainsKey(product)) addedItems.Remove(product);
            addedItems.Add(product, newQuantity);
          }
        }
      }

      List<InvoiceItem> items = new();
      foreach (KeyValuePair<Product, int> item in addedItems)
      {
        items.Add(new InvoiceItem { Product = item.Key, Quantity = item.Value });
      }

      return items;
    }

    private static void DisplayAvailableCommands()
    {
      foreach (var cmd in Program.ALL_CMDS)
      {
        Console.WriteLine($"\t- {cmd},");
      }
    }

    private static void DisplayAllProducts(ShopContext shopContext)
    {
      var query = from product in shopContext.Products
                  select product;

      foreach (var product in query)
      {
        Console.WriteLine($"[{product.ProductID}] {product.ProductName} (dostępne: {product.UnitsInStock})");
      }
      if (query.Count() == 0)
      {
        Console.WriteLine("Brak produktów w bazie danych");
      }
    }

    private static void DisplayAvailableProducts(ShopContext shopContext)
    {
      var query = from product in shopContext.Products
                  where product.UnitsInStock > 0
                  select product;

      foreach (var product in query)
      {
        Console.WriteLine($"[{product.ProductID}] {product.ProductName} (dostępne: {product.UnitsInStock})");
      }
      if (query?.Count() == 0)
      {
        Console.WriteLine("Brak produktów w bazie danych");
      }
    }
  }
}
