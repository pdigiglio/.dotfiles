from typing import List
import lldb
import lldb.formatters.Logger


lldb.formatters.Logger._lldb_formatters_debug_level = 1
logger = lldb.formatters.Logger.Logger()

def TWeakPtrSummaryProvider(valobj: lldb.SBValue, _: dict) -> str:

    def get_summary(valobj: lldb.SBValue) -> str:
        expr = 'Object == 0'
        if valobj.EvaluateExpression(expr).GetValueAsUnsigned():
            return 'nullptr'

        expr = 'WeakReferenceCount.ReferenceController->SharedReferenceCount._Storage._Value == 0'
        if valobj.EvaluateExpression(expr).GetValueAsUnsigned():
            return 'Object has been destroyed'

        expr = "Object != 0"
        if valobj.EvaluateExpression(expr).GetValueAsUnsigned():
            ptr = valobj.EvaluateExpression('(void*)Object')
            deref = valobj.EvaluateExpression('*Object')
            return f'WeakPtr={ptr.value} {deref.value}'

        return '#error'

    summary = get_summary(valobj)
    return f'[{valobj.type.name}] ({summary})'

def TSharedPtrSummaryProvider(valobj: lldb.SBValue, _: dict) -> str:

    def get_summary(valobj: lldb.SBValue) -> str:
        expr = 'Object == 0'
        if valobj.EvaluateExpression(expr).GetValueAsUnsigned():
            return 'nullptr'

        expr = "Object != 0"
        if valobj.EvaluateExpression(expr).GetValueAsUnsigned():
            ptr = valobj.EvaluateExpression('(void*)Object')
            deref = valobj.EvaluateExpression('*Object')
            return f'SharedPtr={ptr.value} {deref.value}'

        return '#error'

    summary = get_summary(valobj)
    return f'[{valobj.type.name}] ({summary})'


class TSharedPtrSyntProvider:
    def __init__(self, valobj: lldb.SBValue, _: dict) -> None:
        self.valobj = valobj
        self.update()


    def num_children(self) -> int:
        return len(self.children)


    def has_children(self) -> bool:
        return True


    def get_child_index(self, name: str) -> int:
        names = [ v.name for v in self.children ]
        return names.index(name)


    def get_child_at_index(self, index: int) -> lldb.SBValue:
        return self.children[index]


    def update(self) -> None:
        expr_opts = lldb.SBExpressionOptions()
        self.children : List[lldb.SBValue] = []

        expr = "Object != 0"
        if self.valobj.EvaluateExpression(expr).unsigned:
            expr = '*Object'
            self.children += [ self.valobj.EvaluateExpression(expr, expr_opts, f'[{expr}]') ]

        # NOTE: how to handle nested printers?


def TVectorSummaryProvider(valobj: lldb.SBValue, _: dict) -> str:
    X = valobj.EvaluateExpression('X')
    Y = valobj.EvaluateExpression('Y')
    Z = valobj.EvaluateExpression('Z')
    return f"[{valobj.type.name}] (X={X.value} Y={Y.value} Z={Z.value})"


class TVectorSyntProvider:
    def __init__(self, valobj: lldb.SBValue, _: dict) -> None:
        self.valobj = valobj
        self.update()


    def num_children(self) -> int:
        return 4


    def has_children(self) -> bool:
        return True


    def get_child_index(self, name: str) -> int:
        names = [ v.name for v in self.children ]
        return names.index(name)


    def get_child_at_index(self, index: int) -> lldb.SBValue:
        return self.children[index]


    def update(self) -> None:
        expr_opts = lldb.SBExpressionOptions()
        self.children : List[lldb.SBValue] = [
             self.valobj.EvaluateExpression('X', expr_opts, 'X'),
             self.valobj.EvaluateExpression('Y', expr_opts, 'Y'),
             self.valobj.EvaluateExpression('Z', expr_opts, 'Z'),
             self.valobj.EvaluateExpression('X * X + Y * Y + Z * Z', expr_opts, '|.|^2')
        ]





# command script import ~/lldb_formatters/vector_formatter.py 
# type synthetic add -l vector_formatter.TVectorSyntProvider  -x "FVector$" -w test
# type summary add -F vector_formatter.TVectorSummaryProvider -e -x "FVector$" -w test
# type category enable test
def __lldb_init_module(debugger: lldb.SBDebugger, dict) -> None:
    namespace = 'vector_formatter'
    category = 'test'

    debugger.HandleCommand(f'type synthetic add -l {namespace}.TVectorSyntProvider       -x "FVector$" -w {category}')
    debugger.HandleCommand(f'type summary   add -F {namespace}.TVectorSummaryProvider -e -x "FVector$" -w {category}')

    debugger.HandleCommand(f'type synthetic add -l {namespace}.TSharedPtrSyntProvider       -x "TSharedPtr<.+>$" -w {category}')
    debugger.HandleCommand(f'type summary   add -F {namespace}.TSharedPtrSummaryProvider -e -x "TSharedPtr<.+>$" -w {category}')

    debugger.HandleCommand(f'type summary   add -F {namespace}.TWeakPtrSummaryProvider   -e -x "TWeakPtr<.+>$" -w {category}')

    debugger.HandleCommand(f'type category enable {category}')
