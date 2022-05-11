namespace MateuszLopacinskiEFProducts
{
  class Program
  {
    static void Main()
    {
      ShopContext shopContext = new ShopContext();
      Product product = createNewProduct();
      Supplier? supplier = null;

      bool isCorrectChoice = false;
      bool createdNewSupplier = false;
      do
      {
        Console.WriteLine("Dodać nowego dostawcę? (tak/nie)");
        string choice = Console.ReadLine();
        switch (choice)
        {
          case "tak":
            isCorrectChoice = true;
            supplier = createNewSupplier();
            createdNewSupplier = true;
            break;
          case "nie":
            isCorrectChoice = true;
            displayAllSuppliers(shopContext);
            supplier = findSupplier(shopContext);
            break;
        }
      } while (!isCorrectChoice);

      Console.WriteLine("Dodaję produkt to dostawcy...");
      product.Supplier = supplier;
      supplier.Products.Add(product);

      Console.WriteLine("Zapisuję dane do bazy...");
      if (createdNewSupplier) shopContext.Suppliers.Add(supplier);
      shopContext.Products.Add(product);
      shopContext.SaveChanges();
    }

    private static Product createNewProduct()
    {
      Console.Write("Podaj nazwę produktu\n>>> ");
      string prodName = Console.ReadLine();
      Console.Write("Podaj liczbę dostępnych sztuk produktu\n>>> ");
      int quantity = Int32.Parse(Console.ReadLine());

      Console.WriteLine("Tworzę nowy produkt...");
      Product product = new Product
      {
        ProductName = prodName,
        UnitsOnStock = quantity
      };
      Console.WriteLine($"Stworzono produkt: {product}");
      return product;
    }

    private static Supplier createNewSupplier()
    {
      Console.Write("\nPodaj nazwę dostawcy\n>>> ");
      string companyName = Console.ReadLine();
      Console.Write("Podaj miasto\n>>> ");
      string city = Console.ReadLine();
      Console.Write("Podaj ulicę\n>>> ");
      string street = Console.ReadLine();

      Console.WriteLine("Tworzę nowego dostawcę...");
      Supplier supplier = new Supplier
      {
        CompanyName = companyName,
        City = city,
        Street = street
      };
      Console.WriteLine($"Stworzono dostawcę: {supplier}");
      return supplier;
    }

    private static Supplier findSupplier(ShopContext shopContext)
    {
      Console.Write("Wprowadź id dostawcy, który ma zostać przypisany do nowego produktu\n>>>");
      int choice = Int32.Parse(Console.ReadLine());

      var query = from sup in shopContext.Suppliers
                  where sup.SupplierID == choice
                  select sup;

      return query.FirstOrDefault();
    }

    private static void displayAllSuppliers(ShopContext shopContext)
    {
      Console.WriteLine("Lista wszystkich dostawców");
      foreach (Supplier supplier in shopContext.Suppliers)
      {
        Console.WriteLine($"[{supplier.SupplierID}] {supplier}");
      }
    }
  }
}
