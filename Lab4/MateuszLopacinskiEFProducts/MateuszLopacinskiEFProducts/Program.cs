namespace MateuszLopacinskiEFProducts
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("Podaj nazwę produktu");
            String prodName = Console.ReadLine();

            Console.WriteLine("Poniżej lista produktów zarejestrowanych w naszej bazie danych");

            ShopContext shopContext = new ShopContext();
            Product product = new Product { ProductName = prodName };
            shopContext.Products.Add(product);
            shopContext.SaveChanges();

            var query = from prod in shopContext.Products
                        select prod.ProductName;

            foreach (var pName in query)
            {
                Console.WriteLine(pName);
            }
        }
    }
}
