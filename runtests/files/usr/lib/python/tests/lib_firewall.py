import collections

class LibFirewall:
    initialized = False

    @classmethod
    def initialize(cls):
        cls.initialized = True

    @classmethod
    def create_rule(cls, action="REJECT", description="_ats_rule", enabled=True, conditions=[]):
        rule = {
            "action": {
                "type": f"{action}"
            },
            "conditions": conditions,
            "description": f"{description}",
            "enabled": enabled
        }
        return collections.OrderedDict(rule)

    @classmethod
    def create_condition(cls, type="DESTINED_LOCAL", op="==", value=True, port_protocol=None):
        condition = {
            "type": type,
            "op": op,
            "value": value
        }
        if port_protocol is not None:
            condition["port_protocol"] = port_protocol
        return collections.OrderedDict(condition)



if LibFirewall.initialized is False:
    LibFirewall.initialize()
