use Test;

my @modules = <
    Date::Utils
>;

plan @modules.elems;

for @modules {
    use-ok "$_", "Module '$_' can be used okay";
}

