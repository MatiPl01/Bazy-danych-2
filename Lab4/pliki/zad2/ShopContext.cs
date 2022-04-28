using Microsoft.EntityFrameworkCore;

namespace MateuszLopacinskiEFProducts
{
  internal class ShopContext : DbContext
  {
    public DbSet<Product> Products { get; set; }
    public DbSet<Supplier> Suppliers { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
      base.OnConfiguring(optionsBuilder);
      optionsBuilder.UseSqlite("Datasource=ProductsDatabase.db");
    }
  }
}
