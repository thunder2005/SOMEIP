using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Swashbuckle.AspNetCore.Swagger;
using Swashbuckle;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.PlatformAbstractions;
using System.IO;
using Swashbuckle.AspNetCore.SwaggerGen;
using Swashbuckle.AspNetCore;
using Swashbuckle.AspNetCore.SwaggerUI;
using System.Reflection;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using System.Runtime.Serialization;

namespace webapi
{
    public class ComplexTypeOperationFilter : IOperationFilter
{
    // public void Apply(Operation operation, SchemaRegistry schemaRegistry, ApiDescription apiDescription)
    // {
    //     if (operation.Parameters == null)
    //         return;

    //     var parameters = apiDescription.ActionDescriptor.();
    //     foreach (var parameter in parameters)
    //     {
    //         foreach (var property in parameter.ParameterType.GetProperties())
    //         {
    //             var param = operation.parameters.FirstOrDefault(o => o.name.ToLowerInvariant().Contains(property.Name.ToLowerInvariant()));

    //             if (param == null) continue;

    //             var name = GetNameFromAttribute(property);

    //             if (string.IsNullOrEmpty(name))
    //             {
    //                 operation.parameters.Remove(param);
    //             }
    //             param.name = GetNameFromAttribute(property);
    //         }
    //     }
    // }
    
    private static string GetNameFromAttribute(PropertyInfo property)
    {
        var customAttributes = property.GetCustomAttributes(typeof(DataMemberAttribute), true);
        if (customAttributes.Length > 0)
        {
            var attribute = customAttributes[0] as DataMemberAttribute;
            if (attribute != null) return attribute.Name;
        }
        return string.Empty;
    }

        public void Apply(Operation operation, OperationFilterContext context)
        {
            return;
            throw new NotImplementedException();
        }
    }
    public class AddSchemaExamples : ISchemaFilter
    {
        public void Apply(Schema model, SchemaFilterContext context)
        {
            if (!string.IsNullOrEmpty(model.Format))
            {
                model.Type = model.Title = model.Format;
            }
            return;
            if (context.SystemType.IsEnum)
            {
                IList<object> tmp = new List<object>();
                foreach (var val in model.Enum)
                {
                    object enumValue;
                    bool b;
                    string Description;
                    b = Enum.TryParse(context.SystemType, val.ToString(), out enumValue);
                    if (b)
                    {
                        string str = enumValue.ToString();
                        System.Reflection.FieldInfo field = enumValue.GetType().GetField(str);
                        object[] objs = field.GetCustomAttributes(typeof(System.ComponentModel.DescriptionAttribute), false);
                        if (objs == null || objs.Length == 0)
                        {
                            Description = val.ToString();
                        }
                        else
                        {
                            System.ComponentModel.DescriptionAttribute da = (System.ComponentModel.DescriptionAttribute)objs[0];
                            Description = da.Description;
                        }

                        string ret = string.Format("0x{0:x2}:{1}", (int)enumValue, Description);
                        tmp.Add(ret);
                    }


                }
                model.Enum = tmp;
            }


            return;
            throw new NotImplementedException();
        }
    }
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        private static string schemaIdStrategy(Type currentClass)
        {
            string returnedValue = currentClass.Name;
            if (returnedValue.EndsWith("DTO"))
                returnedValue = returnedValue.Replace("DTO", string.Empty);
            return returnedValue;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {

            services.AddMvc();
            // Register the Swagger generator, defining one or more Swagger documents
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info
                {
                    Version = "v1",
                    Title = "SOME/IP API",
                    Description = "SOME/IP API",
                    TermsOfService = "None",
                    Contact = new Contact { Name = "Shayne Boyer", Email = "", Url = "https://twitter.com/spboyer" },
                    License = new License { Name = "Use under LICX", Url = "https://example.com/license" }
                });

                // Set the comments path for the Swagger JSON and UI.
                var basePath = PlatformServices.Default.Application.ApplicationBasePath;
                var xmlPath = Path.Combine(basePath, "webapi.xml");
                c.IncludeXmlComments(xmlPath);

                c.CustomSchemaIds(schemaIdStrategy);
                c.SchemaFilter<AddSchemaExamples>();
                //c.SchemaId(t => t.FullName.Contains('`') ? t.FullName.Substring(0, t.FullName.IndexOf('`')) : t.FullName);
                //MapType(Type type, Func<Schema> schemaFactory)
                c.IgnoreObsoleteProperties();
                //c.DescribeStringEnumsInCamelCase();
                c.DescribeAllParametersInCamelCase();
                //c.DescribeAllEnumsAsStrings();

                   c.OperationFilter<ComplexTypeOperationFilter>();

            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
            }

            app.UseStaticFiles();

            // Enable middleware to serve generated Swagger as a JSON endpoint.
            app.UseSwagger();

            // Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.), specifying the Swagger JSON endpoint.
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "SOME/IP API V1");
            });


            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}
