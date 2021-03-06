/*
 * This file is part of funk-as3.
 *
 * funk-as3 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * funk-as3 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Apparat. If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (C) 2010 Joa Ebert
 * http://www.joa-ebert.com/
 */

package flashx.funk.ioc {
import flash.utils.Dictionary

public class BindingModule extends ModuleBase
    implements Module
{
    override public function binds(klass: Class): Boolean
    {
        return _map[klass] != null;
    }

    protected function bind (klass: Class): Binding
    {
        return new Binding(klass, this);
    }

    internal function getInstantiator (klass :Class) :Instantiator
    {
        var inst :Instantiator = _map[klass];
        if (inst == null) {
            return new Instantiator(this, klass);
        }
        return inst;
    }

    internal function alias (fromKlass :Class, toKlass :Class) :void
    {
        var fromInst :Instantiator = _map[fromKlass];
        var toInst :Instantiator = _map[toKlass];
        if (toInst == null) {
            toInst = new Instantiator(this, toKlass);
        }
        if (fromInst != null) {
            if (fromInst._singleton) {
                toInst.asSingleton();
            }
            if (fromInst._provider != null) {
                toInst.setProvider(fromInst._provider);
            }
            if (fromInst._evaluated) {
                toInst.setInstance(fromInst._value);
            }
            for each (var from :Class in fromInst._for) {
                toInst._for.push(from);
            }
        } else {
            toInst._for.push(fromKlass);
        }
        for each (var to :Class in toInst._for) {
            _map[to] = toInst;
        }
    }

    override internal function createInstance (klass :Class) :*
    {
        const instantiator: Instantiator = _map[klass];
        if (instantiator != null) {
            return instantiator.getInstance();
        } else if (klass == Module) {
            return this;
        } else {
            return new klass;
        }
    }

    internal const _map: Dictionary = new Dictionary;
}
}
