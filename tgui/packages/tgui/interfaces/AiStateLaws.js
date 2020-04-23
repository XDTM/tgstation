import { map } from 'common/collections'
import { Fragment } from 'inferno'
import { useBackend } from '../backend'
import { Box, Button, Input, Section } from '../components'

export const AiStateLaws = (props, context) => {
  const { act, data } = useBackend(context)

  const { stated_laws } = data

  return (
    <Fragment>
      <Button
        icon='plus'
        content='Add Law'
        onClick={() =>
          act('add_stated_law')
        }
      />
      <Button
        icon='redo'
        content='Reset to Default'
        onClick={() =>
          act('reset_stated_laws')
        }
      />
      {stated_laws.map(law => {
        return (
          <Fragment>
            <Input
              value={law}
              onChange={(e, value) =>
                act('edit_stated_law', {
                  index: law.index,
                  text: value
                })
              }
            />
            <Button
              icon='caret-up'
              content='Move Up'
              onClick={() =>
                act('move_stated_law_up', {
                  index: law.index
                })
              }
            />
            <Button
              icon='caret-down'
              content='Move Down'
              onClick={() =>
                act('move_stated_law_down', {
                  index: law.index
                })
              }
            />
            <Button
              icon='trash'
              content='Delete'
              onClick={() =>
                act('delete_stated_law', {
                  index: law.index
                })
              }
            />
          </Fragment>
        )
      })}
    </Fragment>
  )
}
