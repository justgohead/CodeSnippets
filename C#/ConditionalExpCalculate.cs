using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.CSharp;
using System.CodeDom.Compiler;
using System.Reflection;

namespace ConditionalExpCalc
{
    /// <summary>
    /// 三目运算符计算类
    /// </summary>
    public class ConditionalExpCalculate
    {
        /// <summary>
        /// 计算三目运算符
        /// </summary>
        /// <param name="expression"></param>
        /// <returns></returns>
        public static object Calc(string expression)
        {
            string code = WrapExpression(expression);
            CSharpCodeProvider csharpCodeProvider = new CSharpCodeProvider();
            //编译的参数
            CompilerParameters compilerParameters = new CompilerParameters();
            compilerParameters.ReferencedAssemblies.Add("System.dll");
            //是否生成可执行文件
            compilerParameters.GenerateExecutable = false;
            //是否生成在内存中
            compilerParameters.GenerateInMemory = true;
            //开始编译
            CompilerResults compilerResults = csharpCodeProvider.CompileAssemblyFromSource(compilerParameters, code);
            if (compilerResults.Errors.Count > 0)
                throw new Exception("表达式编译出错！");
            Assembly objAssembly = compilerResults.CompiledAssembly;
            object objHelloWorld = objAssembly.CreateInstance("Test");
            Type type = objAssembly.GetType("ExpressionCalculate");
            MethodInfo method = type.GetMethod("Calculate");
            return method.Invoke(type, null);
        }

        /// <summary>
        /// 动态类字符串
        /// </summary>
        /// <param name="expression">表达式</param>
        /// <returns></returns>
        private static string WrapExpression(string expression)
        {
            string code = @"using System;
                public class ExpressionCalculate
                {
                    public static object Calculate()
                    {
                        return {0};
                    }
                }";
            return code.Replace("{0}", expression);
        }
    }
}
