namespace MateuszLopacinskiEFProducts
{
    static class Command
    {
        public const string
            ADD = "dodaj",
            SELL = "sprzedaj",
            EXIT = "zamknij";
    }

    class Program
    {
        static void Main()
        {
            ShopContext shopContext = new();

            bool exited = false;
            while (!exited) { 
                switch (GetCommand())
                {
                    case Command.ADD:
                        AddNewProduct(shopContext);
                        break;
                    case Command.SELL:
                        SellProduct(shopContext);
                        break;
                    case Command.EXIT:
                        exited = true;
                        Console.WriteLine("To dzisiaj na tyle, dzięki za współpracę");
                        break;
                    default:
                        Console.WriteLine("Polecenie nie zostało rozpoznane, spróbuj jeszcze raz.");
                        break;
                }
            }

            Console.WriteLine("Zapisuję dane do bazy...");
            shopContext.SaveChanges();
        }

        private static string GetCommand()
        {
            Console.WriteLine("Napisz, co chcesz zrobić. Lista dostępnych komend:");
            DisplayAvailableCommands();
            return Console.ReadLine();
        }

        private static void DisplayAvailableCommands()
        {
            foreach (var property in typeof(Command).GetProperties()) {
                Console.WriteLine($"\t{property.Name},");
            }
        }

        private static void AddNewProduct(ShopContext shopContext)
        {
            Product product = CreateNewProduct();
            Console.WriteLine("Zapisuję produkt do bazy danych...");
            shopContext.Products.Add(product);
        }

        private static void SellProduct(ShopContext shopContext)
        {

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
                UnitsOnStock = quantity
            };
            Console.WriteLine($"Stworzono produkt: {product}");
            return product;
        }

        private static List<Product> ChooseProducts(ShopContext shopContext)
        {
            Console.WriteLine("Wybierz produty z listy. Wpisz numery id produktów oddzielone spacjami.");
            string idString = Console.ReadLine();
            string[] idStringsList = idString.Split(' ');
            int[] idList = new int[idStringsList.Length];
            for (int i = 0; i < idStringsList.Length; i++)
            {
                idList[i] = Int32.Parse(idStringsList[i]);
            }
            
            // TODO - implement me
        }

        private static void DisplayAllProducts()
        {
            // TODO
        }
    }
}
